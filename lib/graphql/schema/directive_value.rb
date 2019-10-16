# frozen_string_literal: true

module GraphQL
  class Schema
    class DirectiveValue < GraphQL::Schema::Member
      def initialize(name:, arguments:, owner:, ast_node: nil)
        @graphql_name = name
        @arguments = stringify_args(arguments)
        @owner = owner
        @ast_node = ast_node
      end

      attr_reader :graphql_name, :arguments, :owner, :ast_node

      private

      def stringify_args(args)
        case args
        when Hash
          next_args = {}
          args.each do |k, v|
            str_k = GraphQL::Schema::Member::BuildType.camelize(k.to_s)
            next_args[str_k] = stringify_args(v)
          end
          next_args
        when Array
          args.map { |a| stringify_args(a) }
        else
          args
        end
      end
    end
  end
end
