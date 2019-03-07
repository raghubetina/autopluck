class ActiveRecord::Associations::CollectionProxy
  def method_missing(message, *args, &block)
    desired_attribute = message.to_s.singularize

    if attribute_names.include?(desired_attribute)
      return pluck(desired_attribute)
    else
      super
    end
  end
end
