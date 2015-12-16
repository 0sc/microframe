module Microframe
  module ORM
    class Connection
      class << self

        def connect
          @@db ||= SQLite3::Database.open(File.join("db", @@dbname + ".sqlite"))
          @@db.results_as_hash = true
          connection
        end

        def retrieve_columns(table)
          @@db.execute2("SELECT * FROM #{table} WHERE id = 0")[0]
        end

        def set_dbname(name)
          @@dbname = name
        end

        def connection
          @@db ||= connect
        end

        def execute(query)
          connection.execute(query)
        end
      end
    end
  end
end
