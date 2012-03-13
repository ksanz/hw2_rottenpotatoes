module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  # Mira si es la columna seleccionada
  def is_selected?(col)
      (@sort == col) ? "hilite" : nil
  end
end
