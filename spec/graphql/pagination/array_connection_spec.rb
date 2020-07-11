# frozen_string_literal: true
require "spec_helper"

describe GraphQL::Pagination::ArrayConnection do
  ARRAY_ITEMS = ConnectionAssertions::NAMES.map { |n| { name: n } }

  class ArrayConnectionWithTotalCount < GraphQL::Pagination::ArrayConnection
    def total_count
      items.size
    end
  end

  let(:schema) {
    ConnectionAssertions.build_schema(
      connection_class: GraphQL::Pagination::ArrayConnection,
      total_count_connection_class: ArrayConnectionWithTotalCount,
      get_items: -> { ARRAY_ITEMS }
    )
  }

  include ConnectionAssertions

  class EightCharacterTestSchema < GraphQL::Schema
    class Query < GraphQL::Schema::Object
      field :items, GraphQL::Types::String.connection_type, null: false

      def items
        ["A", "B", "C", "D", "E"]
      end
    end

    query(Query)
    use GraphQL::Execution::Interpreter
    use GraphQL::Analysis::AST
    use GraphQL::Pagination::Connections
  end

  it "works with eight-character cursors" do
    res = EightCharacterTestSchema.execute("{ items(first: 3, after: \"aaaaaaaa\") { edges { node } } }")
    assert_equal ["A", "B", "C"], res["data"]["items"]["edges"].map { |e| e["node"]}
  end
end
