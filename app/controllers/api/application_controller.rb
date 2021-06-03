class Api::ApplicationController < ApplicationController 
    include ActionController::Cookies
    
    rescue_from SecurityTransgression do |e|
        render json: { message: e.message, error: e.message }, status: :unauthorized
      end
    
      def user_authorize_request
    
        p "user_authorize_request"

        p "Check if using http-only cookie"
        token = session[:user_token]
        
        if !token.present?
          p "Not using http-only is this case, check authorization header instead."
          pattern = /^Bearer /
          token  = request.headers['Authorization']
          token = token.gsub(pattern, '') if token && token.match(pattern)
        end

        if !token.present?
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

      def admin_request
        # for user role checking
      end
    
      def current_user 
        @current_user
      end
  end
  