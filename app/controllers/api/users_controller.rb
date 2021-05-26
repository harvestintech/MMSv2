class Api::UsersController < Api::ApplicationController

    before_action :user_authorize_request, except: [:login]

    def login

        up = params.permit(:email, :password)

        if !User.active.exists?(email: up[:email])
            render json: { message: "user_not_found", error: "user_not_found" }, status: :not_found
            return
        end

        user = User.active.find_by(email: up[:email])
        user = user.try(:authenticate, up[:password])

        if !user
            render status:401, json: {
                message: "username_password_incorrect",
                error: "username_password_incorrect",
                data: nil
            }
            return
        end

        token = JsonWebToken.encode({
            user_id: user.id,
            zh_name: user.zh_name,
            en_name: user.en_name,
            login_at: DateTime.now
        })

        usertoken = user.user_tokens.create({
            token: token,
            login_ip:request.remote_ip,
        })

        if !usertoken.valid?
            render status:401, json: {
                error: "Access Denied",
                message: usertoken.errors.messages,
                data: nil
            }
            return
        end

        # session[:user_token] = usertoken.token

        render json: {
            message: "success",
            error: nil,
            data: {
                token: usertoken.token,
                exp_date: usertoken.expired_at,
                zh_name: user.zh_name,
                en_name: user.en_name
            }
        }

        rescue => e
            render status:500, json: {
                error: "system error",
                message: e.message,
                data: nil
            }

    end

    def profile

        user = @current_user.attributes.except("is_deleted","password_digest","user_role_id")
        user[:user_role] = @current_user.user_role.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: user
        }
    end
    
    def all
        items = User.active

        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.map  { |item|
                user = item.attributes.except("is_deleted","password_digest","user_role_id")
                user[:user_role] = item.user_role.attributes.except("is_deleted")
                user
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def list
        items = User.active
        query = params.permit(:page,:size,:order,:sort,:keywords,:status,:created_from,:created_to)
        page = query[:page].present? ? query[:page] : 1
        size = query[:size].present? ? query[:size] : 25

        order = query[:order].present? ? query[:order] : "en_name"
        sort = query[:sort].present? ? query[:sort] : "desc"

        if query[:keywords].present?
            items = items.where("zh_name ILIKE ? OR en_name ILIKE ? OR email ILIKE ? OR ","%#{query[:keywords]}%","%#{query[:keywords]}%","%#{query[:keywords]}%")
        end
        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(page,size).map  { |item|
                user = item.attributes.except("is_deleted","password_digest","user_role_id")
                user[:user_role] = item.user_role.attributes.except("is_deleted")
                user
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
    
    def get
        item_id = params[:item_id]
        item = User.active.find(item_id)
        
        user = item.attributes.except("is_deleted","password_digest","user_role_id")
        user[:user_role] = item.user_role.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: user
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: "data_not_found", error: "data_not_found" }, status: :not_found
    end

    def create
        form = params.permit(:zh_name,:en_name,:email,:mobile,:user_role_id,:password,:password_confirmation, :is_actived)

        item = User.new(form)

        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save

        user = item.attributes.except("is_deleted","password_digest","user_role_id")
        user[:user_role] = item.user_role.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: user
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def update
        id = params[:item_id]
        item = User.active.find(id.to_i)

        form = params.permit(:zh_name,:en_name,:mobile,:user_role_id,:password,:password_confirmation, :is_actived)
        item.assign_attributes(form)
        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save
        
        user = item.attributes.except("is_deleted","password_digest","user_role_id")
        user[:user_role] = item.user_role.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: user
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: "data_not_found", error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def delete
        item_id = params[:item_id]

        if item_id.to_i == 1
            render json: { error: "delete_super_admin", message: "Super Admin cannot be delete" }, status: :unauthorized
            return
        end
        item = User.active.find(item_id.to_i)

        item.is_deleted = true
        item.save
        render json: {
            message: "success",
            error: nil,
            data: nil
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: "data_not_found", error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

end
