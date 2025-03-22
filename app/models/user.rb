class User < ApplicationRecord
    # ASSOCIATIONS
    has_many :blogs, dependent: :destroy
    has_many :comments, dependent: :destroy
    
    # VALIDATIONS
    validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15 }
    # validates :password
    has_secure_password
    # validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :email, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/ , message: "invalid email format"}

    # CALLBACKS
    before_validation :downcase_and_strip_email
    before_validation :ensure_username_has_value, on: [ :create, :update ]  
    
    # before_create :assign_default_username if username.blank?   # will be redundant because of before_validation: ensure_username_has_value
    after_create :send_welcome_email
    after_update :log_profile_update
    around_destroy :log_user_deletion


    private
        def ensure_username_has_value
            # puts "in ensure_username_has_value"
            if username.blank? && email.present?
                self.username = self.email
            elsif username.present?
                self.username = username.strip
            end
        end

        def downcase_and_strip_email
            # puts "in downcaes_and_strip_email"
            # puts email
            self.email = (email || '').downcase.strip
        end

        def send_welcome_email
            puts "Welcome to blogsite, #{username}"
        end

        def log_profile_update
            Rails.logger.info "User #{self.username} updated their profile"
        end

        def log_user_deletion
            username_temp = self.username
            Rails.logger.info "User #{username} is being deleted"
            yield
            # rescue => err
            #     Rails.logger.error "Error deleting user #{username_temp}: #{err.message}"
            # else
                Rails.logger.info "user #{username_temp} deleted successfully"
        end
end
