/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

/**
 * @fileOverview Preview plugin.
 */

( function() {
	var pluginPath;
	var previewCmd = { modes: { wysiwyg: 1, source: 1 },
		canUndo: false,
		readOnly: 1,
		exec: function( editor ) {

            var sHTML,
				config = editor.config,
				baseTag = config.baseHref ? '<base href="' + config.baseHref + '"/>' : '',
				eventData;

			if ( config.fullPage )
				sHTML = editor.getData().replace( /<head>/, '$&' + baseTag ).replace( /[^>]*(?=<\/title>)/, '$& &mdash; ' + editor.lang.preview.preview );
			else {
				var bodyHtml = '<body ',
					body = editor.document && editor.document.getBody();

				if ( body ) {
					if ( body.getAttribute( 'id' ) )
						bodyHtml += 'id="' + body.getAttribute( 'id' ) + '" ';
					if ( body.getAttribute( 'class' ) )
						bodyHtml += 'class="' + body.getAttribute( 'class' ) + '" ';
				}

				bodyHtml += '>';

				sHTML = editor.config.docType + '<html dir="' + editor.config.contentsLangDirection + '">' +
					'<head>' +
						baseTag +
						'<title>' + editor.lang.preview.preview + '</title>' +
						CKEDITOR.tools.buildStyleHtml( editor.config.contentsCss ) +
					'</head>' + bodyHtml +
						editor.getData() +
					'</body></html>';
			}

			var iWidth = 640,
				// 800 * 0.8,
				iHeight = 420,
				// 600 * 0.7,
				iLeft = 80; // (800 - 0.8 * 800) /2 = 800 * 0.1.
			try {
				var screen = window.screen;
				iWidth = Math.round( screen.width * 0.8 );
				iHeight = Math.round( screen.height * 0.7 );
				iLeft = Math.round( screen.width * 0.1 );
			} catch ( e ) {}

			// (http://dev.ckeditor.com/ticket/9907) Allow data manipulation before preview is displayed.
			// Also don't open the preview window when event cancelled.
			if ( editor.fire( 'contentPreview', eventData = { dataValue: sHTML } ) === false )
                return false;

			var sOpenUrl = '',
				ieLocation;

			if ( CKEDITOR.env.ie ) {
				window._cke_htmlToLoad = eventData.dataValue;
				ieLocation = 'javascript:void( (function(){' + // jshint ignore:line
					'document.open();' +
					// Support for custom document.domain.
					// Strip comments and replace parent with window.opener in the function body.
					( '(' + CKEDITOR.tools.fixDomain + ')();' ).replace( /\/\/.*?\n/g, '' ).replace( /parent\./g, 'window.opener.' ) +
					'document.write( window.opener._cke_htmlToLoad );' +
					'document.close();' +
					'window.opener._cke_htmlToLoad = null;' +
				'})() )';
				// For IE we should use window.location rather than setting url in window.open. (http://dev.ckeditor.com/ticket/11146)
				sOpenUrl = '';
			}

			// With Firefox only, we need to open a special preview page, so
			// anchors will work properly on it. (http://dev.ckeditor.com/ticket/9047)
			if ( CKEDITOR.env.gecko ) {
				window._cke_htmlToLoad = eventData.dataValue;
				sOpenUrl = CKEDITOR.getUrl( pluginPath + 'preview.html' );
			}

			var oWindow = window.open( sOpenUrl, null, 'toolbar=yes,location=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,width=' +
				iWidth + ',height=' + iHeight + ',left=' + iLeft );

			// For IE we want to assign whole js stored in ieLocation, but in case of
			// popup blocker activation oWindow variable will be null. (http://dev.ckeditor.com/ticket/11597)
			if ( CKEDITOR.env.ie && oWindow )
				oWindow.location = ieLocation;

			if ( !CKEDITOR.env.ie && !CKEDITOR.env.gecko ) {
				var doc = oWindow.document;
				doc.open();
				doc.write( eventData.dataValue );
				doc.close();
			}

			return true;
		}
	};

	// Register a plugin named "preview".
} )();

/**
 * Event fired when executing `preview` command, which allows additional data manipulation.
 * With this event, the raw HTML content of the preview window to be displayed can be altered
 * or modified.
 *
 * @event contentPreview
 * @member CKEDITOR
 * @param {CKEDITOR.editor} editor This editor instance.
 * @param data
 * @param {String} data.dataValue The data that will go to the preview.
 */
