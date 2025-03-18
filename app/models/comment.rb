class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :blog

    validates :message, presence: true, length: {in: 1..200}

    before_validation :strip_message
    after_create :log_comment_creation

    private
        def strip_message
            self.message = message.strip unless message.blank?
        end

        def log_comment_creation
            Rails.logger.info("Comment added by user: #{user.username} to blog: #{blog.title}")
        end
end
