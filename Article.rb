class Article

  attr_accessor :article_copy, :current_state, :accept_hash, :reject_hash, :update_array

  def initialize
    @accept_hash = {"Creation" => "Writing", "Writing" => "Editing", "Editing" => "Design", "Final_Review" => "Publish"}
    @reject_hash = {"Creation" => "Creation", "Writing" => "Writing", "Editing" => "Editing", "Final_Review" => "Build"}
    @update_array = ["Creation", "Writing", "Editing"]
  end

  def create
    @current_state = "Creation"
  end

  def set_art!
    if @current_state == "Design"
      @current_state = "Art_Review"
    else
      raise "you can only set art from stage Design"
    end
  end

  def accept_art!
    if @current_state == "Art_Review"
      @current_state = "Build"
    else
      raise "you can only accept art from stage Art Review"
     end
  end

  def reject_art!
    if @current_state == "Art_Review"
      @current_state = "Design"
    else
      raise "you can only reject art from stage Art Review"
    end
  end

  def acceptible?
    return true if @accept_hash.has_key?(@current_state)
  end

  def rejectible?
    return true if @reject_hash.has_key?(@current_state)
  end

  def accept!
    if acceptible?
      @current_state = @accept_hash[@current_state]
    else
      raise "you cannot accept this article from the following state: #{@current_state}"
    end
  end

  def reject!
    if rejectible?
      @current_state = @reject_hash[@current_state]
    else
      raise "you cannot reject this article from the following state: #{@current_state}"
    end
  end

  def updateable?
    return true if @update_array.include?(@current_state)
  end

  def update_copy
    if @current_state == "Final_Review"
      @current_state = "Build"
    elsif updateable?
    else
      raise "you cannot update_copy from this state"
    end
  end

  def build_code
    if @current_state == "Build"
      @current_state = "Preview"
    else
      raise "you can only build code if the state is Build"
    end
  end

  def stage
    if @current_state == "Preview"
      @current_state = "Final_Review"
    else
      raise "you can only stage if the state is Preview"
    end
  end

  def publishable?
    return true if @current_state == "Publish"
  end

  def publish
    if publishable?
      @current_state = "Published"
    else
      raise "you can only Publish an Article who's status is Publish"
    end
  end

  def cancel
    @current_state = "Cancel"
  end

end