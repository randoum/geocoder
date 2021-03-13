# frozen_string_literal: true

module Geocoder
  module Generators
    module MigrationVersion
      def rails_5?
        Rails::VERSION::MAJOR == 5
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails_5?
      end
    end
  end
end
