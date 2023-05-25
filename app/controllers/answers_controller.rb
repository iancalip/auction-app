class AnswersController < ApplicationController
    before_action :authenticate_admin!

    def create
        @question = Question.find(params[:question_id])
        @lot = @question.lot
        @answer = @question.answers.new(params.require(:answer).permit(:content))
        @answer.user = current_user

        if @answer.save
            redirect_to @lot, notice: 'Resposta enviada com sucesso!'
        else
            render @lot
        end
    end


    private

    def authenticate_admin!
        current_user.admin?
    end
end