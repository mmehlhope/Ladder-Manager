class CompetitorSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name, :rating, :wins
end
