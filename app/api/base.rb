class Base < Grape::API
  version 'v1'
  format :json 

  mount V1::User
end
