class QuestionsController < ApplicationController
    before_action :authenticate_user!, only: [:create]
    before_action :authenticate_admin!, only: [:update]

    def create
        @lot = Lot.find(params[:lot_id])
        @question = @lot.questions.new(params.require(:question).permit(:content))
        @question.user = current_user
        if @question.save
            redirect_to @lot, notice: 'Pergunta enviada com sucesso!'
        else
            render @lot
        end
    end

    def update
        @question = Question.find(params[:id])
        if @question.update!(hidden: params[:question][:hidden])
            redirect_to lot_path(@question.lot), notice: 'Pergunta ocultada com sucesso!'
        else
            render @lot
        end
    end

    private

    def authenticate_admin!
        redirect_to root_path, alert: 'Acesso não autorizado.' unless current_user.admin?
    end
end