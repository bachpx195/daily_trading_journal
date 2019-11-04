class Comment < ApplicationRecord
	belongs_to :commentable, polymorphic: true
	
	enum is_importand: {normal: 0, importand: 1}
end
