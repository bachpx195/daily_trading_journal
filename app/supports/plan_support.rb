class PlanSupport
  include CollectiveIdea::Acts::NestedSet::Helper
  
  def initialize plan
    @resource = plan
  end
  
  def options_for_select
    nested_set_options(Plan) {|i| "#{'-' * i.level} #{i.slug}" }
  end
end