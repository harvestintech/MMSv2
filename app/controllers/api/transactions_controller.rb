class Api::TransactionsController < Api::ApplicationController
    before_action :user_authorize_request

    def list
        items = Transaction.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        filter = params.permit(:account_no,:bank_name)

        order = query[:orderBy].present? ? query[:orderBy] : "trans_at"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"

        filter.each {|key,value|
            if value.present?
                items = items.where("#{key} ILIKE ? ","%#{value}%")
            end
        }
        
        transRange = params.permit(:trans_from, :trans_to)
        from = transRange[:trans_from].present? ? transRange[:trans_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = transRange[:trans_to].present? ? transRange[:trans_to].to_time.end_of_day : DateTime.now.end_of_day
        if transRange[:trans_from].present? || transRange[:trans_to].present?
            items = items.where(trans_at: from..to)
        end

        confirmRange = params.permit(:confirm_from, :confirm_to)
        from = confirmRange[:confirm_from].present? ? confirmRange[:confirm_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = confirmRange[:confirm_to].present? ? confirmRange[:confirm_to].to_time.end_of_day : DateTime.now.end_of_day
        if confirmRange[:confirm_from].present? || confirmRange[:confirm_to].present?
            items = items.where(confirm_at: from..to)
        end

        handledRange = params.permit(:handled_from, :handled_to)
        from = handledRange[:handled_from].present? ? handledRange[:handled_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = handledRange[:handled_to].present? ? handledRange[:handled_to].to_time.end_of_day : DateTime.now.end_of_day
        if handledRange[:handled_from].present? || handledRange[:handled_to].present?
            items = items.where(handled_at: from..to)
        end

        receivedRange = params.permit(:received_from, :received_to)
        from = receivedRange[:received_from].present? ? receivedRange[:received_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = receivedRange[:received_to].present? ? receivedRange[:received_to].to_time.end_of_day : DateTime.now.end_of_day
        if receivedRange[:received_from].present? || receivedRange[:received_to].present?
            items = items.where(bank_received: from..to)
        end

        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(offset,size).map  { |item|
                result = item.attributes.except("is_deleted","bank_account_id")
                bank = item.bank_account.attributes.except("is_deleted")
                result[:bank_account] = bank
                result
            }
        }
    rescue => e
        p e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def get
        item_id = params[:item_id]
        item = Transaction.active.find(item_id)
        
        result = item.attributes.except("is_deleted","bank_account_id")
        bank = item.bank_account.attributes.except("is_deleted")
        result[:bank_account] = bank

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
                :trans_at, :trans_type, :trans_desc, :amount, :handled_by, :handled_at,
                :confirm_by, :confirm_at, :bank_ref, :bank_received, :remark
            )

        item = Transaction.new(form)
        item.created_by = @current_user.en_name
        item.updated_by = @current_user.en_name

        bank = params.permit(:bank_account_id)
        if bank[:bank_account_id].present?
            item.bank_account = BankAccount.find(bank[:bank_account_id])
        end

        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save

        result = item.attributes.except("is_deleted","bank_account_id")
        bank = item.bank_account.attributes.except("is_deleted")
        result[:bank_account] = bank

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
        item = Transaction.active.find(id.to_i)

        form = params.permit(
                :trans_at, :trans_type, :trans_desc, :amount, :handled_by, :handled_at,
                :confirm_by, :confirm_at, :bank_ref, :bank_received, :remark
            )

        item.assign_attributes(form)
        item.updated_by = @current_user.en_name

        bank = params.permit(:bank_account_id)
        if bank[:bank_account_id].present?
            item.bank_account = BankAccount.find(bank[:bank_account_id])
        end

        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save
        
        item = Transaction.active.find(id.to_i)
        result = item.attributes.except("is_deleted","bank_account_id")
        bank = item.bank_account.attributes.except("is_deleted")
        result[:bank_account] = bank

        render json: {
            message: "success",
            error: nil,
            data: result
        }

    rescue ActiveRecord::RecordNotFound => e
        p e.message
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
end
