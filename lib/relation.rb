require_relative "01_sql_object"
require_relative "02_searchable"

class Relation
  include Enumerable

  attr_reader :query, :class, :args, :store

  def initialize(passed_class, query, *args)
    @query = query
    @class = passed_class
    @args = args
    @store = nil
  end

  def first
    execute_query
    @store.first
  end

  def last
    @store.last
  end

  def get_all
    execute_query
    self
  end

  def execute_query
    rows = DBConnection.execute(@query, *@args)
    # debugger
    @store = rows.map{|r| @class.new(r)}
  end

  def where(params)
    where_string = params.map{|k, v| " AND #{k} = ?"}.join("")
    @query += where_string
    @args += params.values
  end

end

class Cat < SQLObject
  self.finalize!
end


class SQLObject
  extend Searchable

  def self.find(id)

    find_q = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = ?
    SQL

    relation = Relation.new(self, find_q, id)
    relation.first
  end
end
