module Api
    class OrdersController <Api::BaseController
        def index
            @orders=Order.includes(:tickets).all
            render json: @orders.as_json(include: :tickets)
        end

        def show
            @order=Order.find_by(id: params[:id])
            render json: @order.as_json(include: :tickets)
        end

    end
end

