class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :access_token
end
