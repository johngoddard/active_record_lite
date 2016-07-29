require_relative 'db_connection'
require_relative '01_sql_object'
require_relative 'relation'

module Searchable

  def where(params)

    where_string = params.map{|k, v| "#{k} = ?"}.join(" AND ")
    q = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_string}
    SQL

    res = Relation.new(self, q, *params.values)
  end

end

class SQLObject
  extend Searchable
end
