class ConversationsController < ApplicationController
  def read
    @conversation = Conversation.find(params[:id])

    @conversation.private_messages.each do |private_message|
      if private_message.user != current_user
        private_message.read = true
        private_message.save
      end
    end

    redirect_to conversation_path(@conversation)
  end

  def show
    @conversations = []
    Conversation.all.each do |conversation|
      if conversation.sender_id == current_user.id
        @conversations << conversation
      end
      if conversation.recipient_id == current_user.id
        @conversations << conversation
      end
    end

    # @conversations.sort_by { |conversation| conversation.updated_at }

    @conversation = Conversation.find(params[:id])

    # @conversations.delete(@conversation)

    # @conversations << @conversation

    @private_messages = @conversation.private_messages.order('created_at')

    # if @private_messages.length > 5
    #   @over_five = true
    #   @private_messages = @private_messages[-5..-1]
    # end

    if params[:m]
      @over_five = false
      @private_messages = @conversation.private_messages
    end

    # if @private_messages.last
    #   if @private_messages.last.user_id != current_user.id
    #     @private_messages.last.read = true;
    #   end
    # end

    @private_message = @conversation.private_messages.new
  end

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],
      params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    redirect_to conversation_private_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
