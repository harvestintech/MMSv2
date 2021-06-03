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
        if transRange[:trans_from].present? || transRange[:trans_to].present?
            items = items.date_range_filter("trans_at",transRange[:trans_from], transRange[:trans_to])
        end

        confirmRange = params.permit(:confirm_from, :confirm_to)
        if confirmRange[:confirm_from].present? || confirmRange[:confirm_to].present?
            items = items.date_range_filter("confirm_at",confirmRange[:confirm_from], confirmRange[:confirm_to])
        end

        handledRange = params.permit(:handled_from, :handled_to)
        if handledRange[:handled_from].present? || handledRange[:handled_to].present?
            items = items.date_range_filter("handled_at",handledRange[:handled_from], handledRange[:handled_to])
        end

        receivedRange = params.permit(:received_from, :received_to)
        if receivedRange[:received_from].present? || receivedRange[:received_to].present?
            items = items.date_range_filter("bank_received",receivedRange[:received_from], receivedRange[:received_to])
        end

        amountRange = params.permit(:amount_from, :amount_to)
        if amountRange[:amount_from].present? || amountRange[:amount_to].present?
            items = items.decimal_range_filter("amount",amountRange[:amount_from],amountRange[:amount_to])
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
