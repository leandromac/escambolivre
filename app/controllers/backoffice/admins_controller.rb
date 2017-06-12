class Backoffice::AdminsController < BackofficeController
    before_action :set_admin, only: [:edit, :update, :destroy]
    after_action :verify_authorized, only: :new
    after_action :verify_policy_scoped, only: :index

    def index
        @admins = Admin.all
      # @admins = Admin.with_full_access
        @admins = policy_scope(Admin)
        @admin = Admin.new
    end

    def new
        @admin = Admin.new
        authorize @admin # authorization pundit
    end

    def create
        @admins = Admin.all
        @admin = Admin.new(params_admin)
        if @admin.save
            redirect_to backoffice_admins_path, notice: "Admin <b>#{@admin.name}</b> was successfully save!"
        else
            render :index
        end
    end

    def edit
    end

    def update

        if @admin.update(params_admin)
            redirect_to backoffice_admins_path, notice: "Admin <b>#{@admin.name}</b> was successfully save!"
        else
            render :edit
        end
    end

    def destroy
        authorize @admin # authorization pundit
        admin_email = @admin.email
        if @admin.destroy
            redirect_to backoffice_admins_path, notice: "Admin <b>#{admin_email}</b> was successfully delete!"
        else
            render :index
        end
    end

    private

        def set_admin
            @admin = Admin.find(params[:id])
        end

        def params_admin
        # Permite editar usuário sem a necessidade de mudar a senha...
        pswd = params[:admin][:password]
        pswd_confirmation = params[:admin][:password_confirmation]

        if pswd.blank? && pswd_confirmation.blank?
            params[:admin].delete(:password)
            params[:admin].delete(:password_confirmation)
        end
        # ...fim

            params.require(:admin).permit(:name, :email, :role, :password, :password_confirmation)
        end

end
