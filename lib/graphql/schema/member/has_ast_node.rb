# frozen_string_literal: true
module GraphQL
  class Schema
    class Member
      module HasAstNode
        # If this schema was parsed from a `.graphql` file (or other SDL),
        # this is the AST node that defined this part of the schema.
        def ast_node(new_ast_node = nil)
          if new_ast_node
            @ast_node = new_ast_node
            if new_ast_node.respond_to?(:directives) && method(:directives).arity == 3
              new_ast_node.directives.each do |d|
                directive(d.name, flatten_args(d.arguments), ast_node: d)
              end
            end
          end
          @ast_node
        end

        private

        def flatten_args(arg_value)
          case arg_value
          when Array
            if arg_value.first.is_a?(GraphQL::Language::Nodes::Argument)
              arg_value.each_with_object({}) do |v, h|
                h[v.name] = flatten_args(v)
              end
            else
              arg_value.map { |v| flatten_args(v) }
            end
          else
            arg_value
          end
        end
      end
    end
  end
end
