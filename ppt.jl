#Run this in Escher to visualize a WheelGraph

using LightGraphs
using NetworkViz
using ThreeJS
using Colors


function main(window)
	push!(window.assets, "animation")
    push!(window.assets, "widgets")
    push!(window.assets, "tex")
    push!(window.assets, ("ThreeJS","threejs"))
    num = Input(10)
    toggle = Input(false)
    slidebody(body) = body |> fontsize(1.2em) |> fontweight(400)

    # Complete Graph Example
    completeGraphExample= vbox(
    	title(2,"Complete Graph Example"),
        vskip(2em),
        
        drawGraph(CompleteGraph(8),1)

        ) |> size(80em, 50em)


    # Wheel Graph Example
    wheelGraphExample= vbox(
    	title(2,"Wheel Graph Example"),
        vskip(2em),
        vbox(
            "Number of Nodes",
            slider(10:100) >>> num,
       		
            "2D/3D",
            vskip(1em),
            togglebutton() >>> toggle
        ),
        vskip(1em),
        lift(toggle,num) do t,n
            drawWheel(n,t)
        end
        ) |> size(80em, 50em)



  
   
    # Display begins here
    slideshow([
    
    vbox(title(4,"NetworkViz.jl")),
    
    md"""
    NetworkViz.jl is a 3D graph visualization library in Julia.
    """ |> slidebody,

    completeGraphExample,
    
    wheelGraphExample,

    md"""
    Next slide
    """ |>slidebody



    ])
end


