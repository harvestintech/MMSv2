class Api::PaymentTypesController < Api::ApplicationController
    before_action :user_authorize_request

    def all
        items = PaymentType.active

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
        items = PaymentType.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        filter = params.permit(:name)

        order = query[:orderBy].present? ? query[:orderBy] : "name"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"

        filter.each {|key,value|
            if value.present?
                items = items.where("#{key} ILIKE ? ","%#{value}%")
            end
        }
            
        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(offset,size).map  { |item|
                result = item.attributes.except("is_deleted")
                result
            }
        }
    rescue => e
        p e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def create
        form = params.permit(
                :name, :desc
            )

        item = PaymentType.new(form)
        item.created_by = @current_user.en_name
        item.updated_by = @current_user.en_name


        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save

        result = item.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: result
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def update
        id = params[:item_id]
        item = PaymentType.active.find(id.to_i)

        form = params.permit(
                :name, :desc
            )
        item.assign_attributes(form)
        item.updated_by = @current_user.en_name

        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save
        
        item = PaymentType.active.find(id.to_i)
        result = item.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: result
        }

    rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

end
