class TagSupport
  include CollectiveIdea::Acts::NestedSet::Helper
  
  def initialize tag
    @resource = tag
  end
  
  def options_for_select
    nested_set_options(Tag) {|i| "#{'-' * i.level} #{i.slug}" }
  end
end