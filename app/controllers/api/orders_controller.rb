module Api
    class OrdersController <Api::BaseController
        before_action :api_authorize_participant!
        def index
            @orders=Order.includes(:tickets).all
            render json: @orders.as_json(include: :tickets)
        end

        def show
            @order=Order.find_by(id: params[:id])
            render json: @order.as_json(include: :tickets)
        end

        def mytickets
            @participant=current_resource_owner.userable
            @orders=@participant.orders
            render 'show', status: :ok

        end
        
    end
end

