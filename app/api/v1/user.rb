module V1
  class User < Grape::API
    resource :users do

      # GET /api/v1/users
      desc 'Retrun all user'
      get '/' do
        ::User.all
      end

      # GET /api/v1/users/{:id}
      desc 'Retrun a user'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        ::User.find(params[:id])
      end

      # GET /api/v1/users/{:user_id}/attendances
      desc 'Retrun all attendances'
      params do
        requires :user_id, type: Integer
      end
      get '/:user_id/attendances' do
        ::Attendance.where(user_id: params[:user_id])
      end

    end      
  end
end
