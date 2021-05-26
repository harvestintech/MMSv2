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
        query = params.permit(:offset,:limit,:orderBy,:sortBy,:name,:status)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        order = query[:orderBy].present? ? query[:orderBy] : "name"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"

        if query[:name].present?
            items = items.where("name ILIKE ?","%#{query[:name]}%")
        end
        
        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(offset,size).map  { |item|
                role = item.attributes.except("is_deleted")
                role
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
end
