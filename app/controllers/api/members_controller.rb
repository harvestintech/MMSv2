class Api::MembersController < Api::ApplicationController
    before_action :user_authorize_request

    def list
        items = Member.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        order = query[:orderBy].present? ? query[:orderBy] : "updated_at"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"
        
        filter = params.permit(
            :zh_first_name,:zh_last_name, :en_first_name, :en_last_name,
            :email,:phone, :work_phone, :hkid, :gender, :birth_year, :birth_month, :birth_date, 
            :address1, :address2, :city, :state, :country, :zip_code, 
            :post_address1, :post_address2, :post_city, :post_state, :post_country, :post_zip_code,
            :company, :company_address, :department, :position, :employment_type
        )

        filter.each {|key,value|
            if value.present?
                items = items.where("#{key} ILIKE ? ","%#{value}%")
            end
        }

        applyRange = params.permit(:apply_from, :apply_to)
        from = applyRange[:apply_from].present? ? applyRange[:apply_from].to_time.beginning_of_day : "1900-01-01".to_time.beginning_of_day
        to = applyRange[:apply_to].present? ? applyRange[:apply_to].to_time.end_of_day : DateTime.now.end_of_day
        if applyRange[:apply_from].present? || applyRange[:apply_to].present?
            items = items.where(apply_at: from..to)
        end

        createdRange = params.permit(:created_from, :created_to)
        items = items.creation_range(createdRange[:created_from], createdRange[:created_to])

        updatedRange = params.permit(:updated_from, :updated_to)
        items = items.updated_range(updatedRange[:updated_from], updatedRange[:updated_to])
            
        items = items.order(order => sort)
        render json: {
            message: "success",
            error: nil,
            count: items.count,
            data: items.paginate(offset,size).map  { |item|
                member = item.attributes.except("is_deleted")
                member
            }
        }
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def get
        item_id = params[:item_id]
        item = Member.active.find(item_id)
        
        member = item.attributes.except("is_deleted")
        member[:memberships] = item.memberships.map{ |ship| 
            ship.attributes.except("is_deleted")
        }
        render json: {
            message: "success",
            error: nil,
            data: member
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def create
        form = params.permit(
                :zh_first_name,:zh_last_name, :en_first_name, :en_last_name,
                :email,:phone, :work_phone, :hkid, :gender, :birth_year, :birth_month, :birth_date, 
                :address1, :address2, :city, :state, :country, :zip_code, 
                :post_address1, :post_address2, :post_city, :post_state, :post_country, :post_zip_code,
                :company, :company_address, :department, :position, :employment_type, :status, :apply_at
            )

        item = Member.new(form)
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

        user = item.attributes.except("is_deleted")

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
        item = Member.active.find(id.to_i)

        form = params.permit(
                :zh_first_name,:zh_last_name, :en_first_name, :en_last_name,
                :email,:phone, :work_phone, :hkid, :gender, :birth_year, :birth_month, :birth_date, 
                :address1, :address2, :city, :state, :country, :zip_code, 
                :post_address1, :post_address2, :post_city, :post_state, :post_country, :post_zip_code,
                :company, :company_address, :department, :position, :employment_type, :status, :apply_at
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
        
        item = Member.active.find(id.to_i)
        member = item.attributes.except("is_deleted")

        render json: {
            message: "success",
            error: nil,
            data: member
        }

    rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end
end
