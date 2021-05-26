class Api::RolesController < Api::ApplicationController

    before_action :user_authorize_request

    def all
        items = UserRole.active

        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.map  { |item|
                role = item.attributes.except("is_deleted")
                role
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def list
        items = UserRole.active
        query = params.permit(:page,:size,:order,:sort,:keywords,:status,:created_from,:created_to)
        page = query[:page].present? ? query[:page] : 1
        size = query[:size].present? ? query[:size] : 25

        order = query[:order].present? ? query[:order] : "name"
        sort = query[:sort].present? ? query[:sort] : "desc"

        if query[:keywords].present?
            items = items.where("name ILIKE ?","%#{query[:keywords]}%")
        end
        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(page,size).map  { |item|
                role = item.attributes.except("is_deleted")
                role
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
end
