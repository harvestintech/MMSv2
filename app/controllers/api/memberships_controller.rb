class Api::MembershipsController < Api::ApplicationController
    before_action :user_authorize_request

    def list
        items = Membership.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        order = query[:orderBy].present? ? query[:orderBy] : "updated_at"
        sort = query[:sortBy].present? ? query[:sortBy] : "desc"
        
        filter = params.permit(
                :membership_ref, :approved_by, :year, :status, :remark
            )

        filter.each {|key,value|
            if value.present?
                items = items.where("#{key} ILIKE ? ","%#{value}%")
            end
        }

        approvedRange = params.permit(:approved_from, :approved_to)
        if approvedRange[:approved_from].present? || approvedRange[:approved_to].present?
            items = items.date_range_filter("apply_at",approvedRange[:approved_from], approvedRange[:approved_to])
        end

        expiredRange = params.permit(:expried_from, :expried_to)
        if expiredRange[:expried_from].present? || expiredRange[:expried_to].present?
            items = items.date_range_filter("expired_at",expiredRange[:expried_from], expiredRange[:created_to])
        end

        updatedRange = params.permit(:updated_from, :updated_to)
        if updatedRange[:updated_from].present? || updatedRange[:updated_to].present?
            items = items.date_range_filter("updated_at",updatedRange[:updated_from], updatedRange[:updated_to])
        end

        createdRange = params.permit(:created_from, :created_to)
        if createdRange[:created_from].present? || createdRange[:created_to].present?
            items = items.date_range_filter("created_at",createdRange[:created_from], createdRange[:created_to])
        end

        updatedRange = params.permit(:updated_from, :updated_to)
        if updatedRange[:updated_from].present? || updatedRange[:updated_to].present?
            items = items.date_range_filter("updated_at",updatedRange[:updated_from], updatedRange[:updated_to])
        end
            
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
        item = Membership.active.find(item_id)
        
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

    def create
        form = params.permit(
                :member_id, :membership_ref, :approved_by, :approved_at, :year, :expired_at,
                :status, :remark
            )

        raise ActiveRecord::RecordNotFound unless form[:member_id].present?
        
        member = Member.active.find(form[:member_id])

        item = Membership.new(form)
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
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message, error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def update
        id = params[:item_id]
        item = Membership.active.find(id.to_i)

        form = params.permit(
                :member_id, :membership_ref, :approved_by, :approved_at, :year, :expired_at,
                :status, :remark
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
        
        item = Membership.active.find(id.to_i)
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
