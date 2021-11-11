# frozen_string_literal: true

require 'psych'

FactoryBot.define do
  factory :psych_node, class: 'Psych::Nodes::Node' do
    transient do
      children { [] }
    end

    after(:build) do |node, evaluator|
      node.children&.push(*evaluator.children)
    end

    factory :stream_node, class: 'Psych::Nodes::Stream'
    factory :document_node, class: 'Psych::Nodes::Document'
    factory :scalar_node, class: 'Psych::Nodes::Scalar' do
      initialize_with { new(value) }
    end
    factory :alias_node, class: 'Psych::Nodes::Alias' do
      initialize_with { new(anchor) }
    end
  end
end
