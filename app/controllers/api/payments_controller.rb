class Api::PaymentsController < Api::ApplicationController
    before_action :user_authorize_request

    def list
        items = Payment.active
        query = params.permit(:offset,:limit,:orderBy,:sortBy)
        offset = query[:offset].present? ? query[:offset] : 0
        size = query[:limit].present? ? query[:limit] : 25

        filter = params.permit(:paid_to,:approved_by,:handled_by,:receipt_ref, :status)

        order = query[:orderBy].present? ? query[:orderBy] : "en_name"
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
                result = item.attributes.except("is_deleted",'receipt_file_name','receipt_content_type','receipt_file_size')
                if item.receipt_file_name.nil?
                    registration[:receipt] = nil
                else
                    registration[:receipt] = {
                        :url => item.receipt.url(:original),
                        :filename => item.receipt_file_name,
                        :filesize => item.receipt_file_size
                    }
                end
                result
            }
        }
    rescue => e
        p e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def get

    end

    def create

    end

    def update

    end
end
