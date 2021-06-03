class Api::BankAccountsController < Api::ApplicationController
    before_action :user_authorize_request

    def all
        items = BankAccount.active

        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.map  { |item|
                result = item.attributes.except("is_deleted")
                result
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def list
        items = BankAccount.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        filter = params.permit(:account_no,:bank_name)

        order = query[:orderBy].present? ? query[:orderBy] : "bank_name"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"

        filter.each {|key,value|
            if value.present?
                items = items.where("#{key} ILIKE ? ","%#{value}%")
            end
        }
        
        createdRange = params.permit(:created_from, :created_to)
        from = createdRange[:created_from].present? ? createdRange[:created_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = createdRange[:created_to].present? ? createdRange[:created_to].to_time.end_of_day : DateTime.now.end_of_day
        if createdRange[:created_from].present? || createdRange[:created_to].present?
            items = items.where(bank_created_at: from..to)
        end

        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(offset,size).map  { |item|
                user = item.attributes.except("is_deleted")
                user
            }
        }
    rescue => e
        p e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def get
        item_id = params[:item_id]
        item = BankAccount.active.find(item_id)
        
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

    def create
        form = params.permit(
                :bank_name, :account_no, :remark, :bank_created_at
            )

        item = BankAccount.new(form)
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
        item = BankAccount.active.find(id.to_i)

        form = params.permit(
                :bank_name, :account_no, :remark, :bank_created_at
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
        
        item = BankAccount.active.find(id.to_i)
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

    def delete
        item_id = params[:item_id]

        item = BankAccount.active.find(item_id.to_i)

        item.is_deleted = true
        item.save
        render json: {
            message: "success",
            error: nil,
            data: nil
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
end
