# frozen_string_literal: true

module GraphQL
  class Schema
    class Member
      module HasDirectives
        # Add a directive to this member of the schema, with the provided arguments.
        #
        # Arguments are stored as camelized strings and they aren't type-checked.
        #
        # They're attached to this Ruby object, and they're dumped in {Schema.to_definition}.
        #
        # @param name [Symbol]
        # @param arguments [Hash<Symbol => Object>]
        def directive(name, ast_node: nil, **arguments)
          directive_value = Schema::DirectiveValue.new(name: name, arguments: arguments, owner: self, ast_node: ast_node)
          @own_directives[name] = arguments
        end

        # Read all directives of this member, including inherited ones.
        # @return [Hash<Symbol => Hash<Symbol => Object>]
        def directives
          inherited_directives = find_inherited_value(:directives, EMPTY_HASH)
          if inherited_directives.empty?
            own_directives
          else
            inherited_directives.merge(own_directives)
          end
        end

        private

        def own_directives
          @own_directives ||= {}
        end
      end
    end
  end
end