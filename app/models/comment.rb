class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :post
    
    # validations
    
    validates_presence_of :text, :user, :post
    
end
