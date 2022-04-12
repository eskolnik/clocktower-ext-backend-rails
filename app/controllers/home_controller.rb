class HomeController < ApplicationController
  def index
    redirect_to "https://docs.google.com/document/d/e/2PACX-1vQ3Am2-eAzgzBX-CRZc-S2l9q1-OyCv0lv9Tw_NjF8fBUhbQ5bA0ivIUOwVADsZtudZ2qynZirKC2Ii/pub", allow_other_host: true
  end
end
