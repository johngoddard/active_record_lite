require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    "#{@class_name.downcase}s"
  end
end

class BelongsToOptions < AssocOptions
  attr_reader :foreign_key, :primary_key, :class_name
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || (name.to_s + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
  end

end

class HasManyOptions < AssocOptions
  attr_reader :foreign_key, :primary_key, :class_name

  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || (self_class_name.downcase.to_s + "_id").to_sym
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || name.to_s.singularize.camelcase
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method name do
      foreign_key = self.send(options.foreign_key)
      model_c = options.model_class
      res = model_c.where(options.primary_key => foreign_key).first
    end

    assoc_options[options.class_name.underscore.to_sym] = options
  end

  def has_many(name, options = {})

    options = HasManyOptions.new(name, self.to_s, options)

    define_method name do
      primary_key = self.send(options.primary_key)
      model_c = options.model_class
      res = model_c.where(options.foreign_key => primary_key)
    end

  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
