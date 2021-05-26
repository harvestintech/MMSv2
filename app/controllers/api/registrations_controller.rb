class Api::RegistrationsController < Api::ApplicationController

    before_action :user_authorize_request, except: [:create]

    def list

    end

    def get
        items = Registration.active
        query = params.permit(:page, :size:)
    end

    def create
        
        form = params.permit(
                :zh_first_name,:zh_last_name, :en_first_name, :en_last_name,
                :email,:phone, :work_phone, :hkid, :gender, :birth_year, :birth_month, :birth_date, 
                :address1, :address2, :city, :state, :country, :zip_code, 
                :post_address1, :post_address2, :post_city, :post_state, :post_country, :post_zip_code,
                :company, :company_address, :department, :position, :employment_proof, :employment_type, 
                :declare, :agreement 
            )

        item = Registration.new(form)

        if !item.valid?
            render status:500, json: {
                error: "invalid",
                message: item.errors.messages,
                data: nil
            }
            return
        end
        item.save

        result = item.attributes.except(
            'is_deleted','member_id','employment_proof_file_name','employment_proof_content_type','employment_proof_file_size','uuid'
        )

        if item.employment_proof_file_name.nil?
            result[:employment_proof] = nil
        else
            result[:employment_proof] = {
                :url => item.employment_proof.url(:original),
                :filename => item.employment_proof_file_name,
                :filesize => item.employment_proof_file_size
            }
        end

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
        item = Registration.active.find(id.to_i)

        form = params.permit(
                :zh_first_name,:zh_last_name, :en_first_name, :en_last_name,
                :email,:phone, :work_phone, :hkid, :gender, :birth_year, :birth_month, :birth_date, 
                :address1, :address2, :city, :state, :country, :zip_code, 
                :post_address1, :post_address2, :post_city, :post_state, :post_country, :post_zip_code,
                :company, :company_address, :department, :position, :employment_proof, :employment_type, 
                :declare, :agreement, :status, :remark
            )
        p form
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
        result = item.attributes.except(
            'is_deleted','member_id','employment_proof_file_name','employment_proof_content_type','employment_proof_file_size','uuid'
        )

        if item.employment_proof_file_name.nil?
            result[:employment_proof] = nil
        else
            result[:employment_proof] = {
                :url => item.employment_proof.url(:original),
                :filename => item.employment_proof_file_name,
                :filesize => item.employment_proof_file_size
            }
        end

        render json: {
            message: "success",
            error: nil,
            data: result
        }
    rescue ActiveRecord::RecordNotFound => e
        render json: { message: "data_not_found", error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

    def approve
        item_id = params[:item_id]
        item = Registration.active.find(id.to_i)

        if item.member_id.present?
            render status:500, json: {
                message: "item handled by #{item.handled_by}",
                error: "handled_item",
                data: nil
            }
            return
        end

        item.status = "Approved";
        item.handled_by = @current_user.zh_name
        item.handled_at = DateTime.now

    rescue ActiveRecord::RecordNotFound => e
        render json: { message: "data_not_found", error: "data_not_found" }, status: :not_found
    rescue => e
        render json: { error: "system_error", message: e.message }, status: :internal_server_error
    end

end
