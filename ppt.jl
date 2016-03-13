#NetworkViz.jl demo

using LightGraphs
using NetworkViz
using ThreeJS
using Colors


function main(window)
	push!(window.assets, "animation")
    push!(window.assets, "widgets")
    push!(window.assets, "tex")
    push!(window.assets, "layout2")
    push!(window.assets, ("ThreeJS","threejs"))
    num = Input(10)
    toggle = Input(false)
    slidebody(body) = body |> fontsize(1.2em) |> lineheight(2em) 


    tabbar = tabs([
    			hbox(icon("face"), hskip(1em), "3D"),
    			hbox(icon("explore"), hskip(1em), "2D"),
			])

	tabcontent = pages([
		drawGraph(CompleteGraph(6),1),
		drawGraph(CompleteGraph(6),0),
	])

	t, p = wire(tabbar, tabcontent, :tab_channel, :selected)

    # Complete Graph Example
    completeGraphExample= vbox(
    	title(2,"Complete Graph Example"),
        vskip(2em),
        "Visualization of a complete graph with 6 nodes.",
        vskip(2em),

        vbox(t,p)
        
        #drawGraph(CompleteGraph(6),1)

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
    
    vbox(
        title(3,"What have we worked on?"),
        vskip(2.5em),
        "We have created a graph visualization library in Julia language which allows for both 2D and 3D visualizations of graphs which can be input by the users. We have also incorporated zoom capability to allow the library to be used for a multitude of applications including education, traffic signal network visualisation, complex internet network visualizations etc. in which everything revolves around graphs and our ability to perceive and comprehend them."
    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"What is Julia?"),
        vskip(2.5em),
        md"""
        Julia is a high-level, high-performance dynamic programming language for technical computing, with syntax that is familiar to users of other technical computing environments. It is also a NumFocus project started by students at MIT which was commercialised in 2012 and is now a full fledged startup, Julia Computing.
        """
    ) |>slidebody |> pad(6em),


    vbox(
        title(3,"Why Julia?"),
        vskip(2.5em),
        md"""
        Julia’s LLVM-based just-in-time (JIT) compiler combined with the language’s design allow it to approach and often match the performance of C. This allows for the ease of use of languages similar to python at the performance of C.
        """,
        vskip(2em),
        # image("https://drive.google.com/file/d/0B414CCVd1zpIT2doRjZxLXppekY4SmEydkx1YllJbk16UVRR/view?usp=sharing")

        image("/pkg/Escher/whyjulia.jpg")

    ) |>slidebody |> pad(6em),

    vbox(
        title(3,"What have we achieved?"),
        vskip(2.5em),
        md"""
        We have managed to create a stable, robust graph visualization library which allows the user to bring any graph or operational result to life through a 3D/2D visualization of the same.

        Salient features of our project:

        - Allows for easy toggling between 2D and 3D representations of the graph, i.e.  any graph which is input would result in a visualization being rendered which can be switched from 2D to 3D by changing the z-axis parameter allowing for a more vibrant experience.

        - Only requires adjacency matrix for graph visualization; any and all graphs to be input by the user can be done using an adjacency matrix which would now provide the opportunity to visualize the effect of various graph operations on the graph structure

        - Tight coupling with existing(non-visualization) graph libraries in Julia which allows for easier expansions in the future along with stronger credibility within the Julia community.

        - Zoom capability for careful examination of the graph and its intricate structural changes due to various operations and for viewing the larger layout of the graph allowing for a wider network topology view of the graph.
        """

    ) |>slidebody |> pad(6em),

    completeGraphExample,
    
    wheelGraphExample |> pad(2em),

    vbox(
        title(3,"Where do we go from here?"),
        vskip(2.5em),
        md"""
        We hope to expand our library to support extensive animations that would further our goal of creating a library which allows users to perceive and understand some of the most complex network structures be it in city management or educational circles. 
        We also imagine it to have specific applications in the area of network topology visualization which would allow for it to be used as an instrumental part of network configuration simulators.

        Another interesting real-world application we can hope to target is a simple way to visualize complex city road structures and signals which currently require specialists trained in traffic network simulators like SUMO, using our library it would be a far simpler task to work off of a gui which allows you to views the entire traffic network at a glance and also zero in on specific locations in the city layout.
        """
    ) |>slidebody |> pad(6em),

        vbox(
        title(3,"What is our next step?"),
        vskip(2.5em),
        md"""
        The third Julia conference will take place June 21st-25th, 2016 at the Massachusetts Institute of Technology in Cambridge, Massachusetts. We hope to present a talk at this prestigious conference on our work with NetworkViz.jl library and have started preparations to achieve the same.

        We also hope to submit a research paper on our work to the SummerSim’16 conference to be held from July 24-27, 2016 at Palais des congres de Montreal, Quebec, Canada which is a conference focussed on modeling and simulation tools, theory, methodologies and applications and is thus a forum for the latest R&D results in academia and industry.
        """
    ) |>slidebody |> pad(6em),


    



    ])
end


