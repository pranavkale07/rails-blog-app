class Blog < ApplicationRecord
    # ASSOCIATIONS
    belongs_to :user
    has_many :comments, dependent: :destroy
    
    # VALIDATIONS
    validates :title, presence: true, length: {in: 5..100}
    validates :content, presence: true

    # CALLBACKS
    before_validation :strip_title_and_content
    before_validation :set_default_blog_title_and_content
    after_create :log_blog_creation


    private
        def set_default_blog_title_and_content
            self.title = "#{user.username}'s blog post" if title.blank? && user.present?
            self.content = "my awesome blog" if content.blank?
        end

        def strip_title_and_content
            self.title = title.strip if title.present?
            self.content = content.strip if content.present?
        end

        def log_blog_creation
            Rails.logger.info "Blog #{title} created successfully"
        end

end
