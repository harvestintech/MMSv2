class Api::ApplicationController < ApplicationController 
    include ActionController::Cookies
    
    rescue_from SecurityTransgression do |e|
        render json: { message: e.message, error: e.message }, status: :unauthorized
      end
    
      def user_authorize_request
    
        pattern = /^Bearer /
        token  = request.headers['Authorization']
        token = token.gsub(pattern, '') if token && token.match(pattern)

        # p token
        # if token.nil? 
        #   token = session[:user_token]          
        # end

        if token.nil?
            render json: { message: "token_not_found", error: "token_not_found" }, status: :unauthorized
            return
        end
        if !UserToken.active.exists?(token: token)
          render json: { message: "token_expired", error: "token_expired" }, status: :unauthorized
          return
        end
        begin
          @decoded = JsonWebToken.decode(token)
          
          @current_user = User.active.find(@decoded[:user_id])
          
        rescue ActiveRecord::RecordNotFound => e
          render json: { message: e.message, error: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { message: e.message, error: e.message }, status: :unauthorized
        end
      end
    
      def current_user 
        @current_user
      end
  end
  