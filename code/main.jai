
#import "Basic";
#import "Math";
#import "Hash_Table";
#import "SDL";
#import "GL";

#import "gylib" (
	DEBUG_BUILD = false,
	ASSERT_FAILURE_FUNC = AssertionFailure,
	DEBUG_OUTPUT_FUNC = GylibDebugOutput,
	DEBUG_OUTPUT_LVL_PREFIX = false);

#load "settings.jai";


vertexShaderSource ::
#string END
	#version 330 core
	layout (location = 0) in vec3 aPos;
	void main()
	{
	   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
	}
END

fragmentShaderSource ::
#string END
	#version 330 core
	out vec4 FragColor;
	void main()
	{
	   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
	}
END

CompileShader :: () -> (bool, GLuint)
{
	success: GLint;
	infoLog: [512]GLchar;
	
	// vertex shader
	vertexShader := glCreateShader(GL_VERTEX_SHADER);
	defer glDeleteShader(vertexShader);
	vertexSourceCstr := cast(*GLchar)temp_c_string(vertexShaderSource);
	vertexSourceLength := cast(GLint)vertexShaderSource.count;
	glShaderSource(vertexShader, 1, *vertexSourceCstr, *vertexSourceLength);
	glCompileShader(vertexShader);
	// check for shader compile errors
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, *success);
	if (!success)
	{
		glGetShaderInfoLog(vertexShader, 512, null, infoLog.data);
		PrintLine_E("Vertex Shader Compilation Failed!\n%", infoLog);
		return (false, 0);
	}
	
	// fragment shader
	fragmentShader := glCreateShader(GL_FRAGMENT_SHADER);
	defer glDeleteShader(fragmentShader);
	fragmentSourceCstr := cast(*GLchar)temp_c_string(fragmentShaderSource);
	fragmentSourceLength := cast(GLint)fragmentShaderSource.count;
	glShaderSource(fragmentShader, 1, *fragmentSourceCstr, *fragmentSourceLength);
	glCompileShader(fragmentShader);
	// check for shader compile errors
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, *success);
	if (!success)
	{
		glGetShaderInfoLog(fragmentShader, 512, null, infoLog.data);
		PrintLine_E("Fragment Shader Compilation Failed!\n%", infoLog);
		return (false, 0);
	}
	
	// link shaders
	shaderProgram := glCreateProgram();
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	glLinkProgram(shaderProgram);
	// check for linking errors
	glGetProgramiv(shaderProgram, GL_LINK_STATUS, *success);
	if (!success)
	{
		glGetProgramInfoLog(shaderProgram, 512, null, infoLog.data);
		PrintLine_E("Shader Linking Failed!\n%", infoLog);
		glDeleteProgram(shaderProgram);
		return (false, 0);
	}
	
	return (true, shaderProgram);
}

CreateSquareVboVaoEbo :: () -> (bool, vboId: GLuint, vaoId: GLuint, eboId: GLuint)
{
	vertices := float.[
	     0.5,  0.5, 0.0,  // top right
	     0.5, -0.5, 0.0,  // bottom right
	    -0.5, -0.5, 0.0,  // bottom left
	    -0.5,  0.5, 0.0   // top left 
	];
	indices := u32.[
	    0, 1, 3,  // first Triangle
	    1, 2, 3   // second Triangle
	];
	vboId, vaoId, eboId: GLuint;
	glGenVertexArrays(1, *vaoId);
	glGenBuffers(1, *vboId);
	glGenBuffers(1, *eboId);
	// bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
	glBindVertexArray(vaoId);
	
	glBindBuffer(GL_ARRAY_BUFFER, vboId);
	glBufferData(GL_ARRAY_BUFFER, size_of(type_of(vertices[0])) * vertices.count, vertices.data, GL_STATIC_DRAW);
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, eboId);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, size_of(type_of(indices[0])) * indices.count, indices.data, GL_STATIC_DRAW);
	
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * size_of(float), cast(*void)(0));
	glEnableVertexAttribArray(0);
	
	// note that this is allowed, the call to glVertexAttribPointer registered vboId as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
	glBindBuffer(GL_ARRAY_BUFFER, 0); 
	
	// remember: do NOT unbind the EBO while a vaoId is active as the bound element buffer object IS stored in the vaoId; keep the EBO bound.
	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	
	// You can unbind the vaoId afterwards so other vaoId calls won't accidentally modify this vaoId, but this rarely happens. Modifying other
	// VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
	glBindVertexArray(0);
	
	return (true, vboId, vaoId, eboId);
}

main :: ()
{
	SetupMemoryArenas();
	
	WriteLine_O("Hello from jai!");
	PrintLine_D("Running from: \"%\"", get_working_directory());
	
	SDL_Init(SDL_INIT_VIDEO);
	defer SDL_Quit();
	
	windowSize := NewVec2i(640, 480);
	window := SDL_CreateWindow(
		"Jai Gylib Test!",
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		windowSize.x, windowSize.y,
		SDL_WINDOW_OPENGL|SDL_WINDOW_RESIZABLE
	);
	if (window == null)
	{
		PrintLine_E("Failed to create SDL window! %", to_string(SDL_GetError()));
		return;
	}
	defer SDL_DestroyWindow(window);
	
	glContext := SDL_GL_CreateContext(window);
	if (glContext == null)
	{
		PrintLine_E("Failed to get OpenGL context from SDL window! %", to_string(SDL_GetError()));
		return;
	}
	
	// using gl; //this global comes from glad_core.jai and stores all the OpenGL procedures
	gl_load(*gl, SDL_GL_GetProcAddress);
	
	shaderCompiledSuccessfully, testShader := CompileShader();
	if (!shaderCompiledSuccessfully) { return; }
	defer glDeleteProgram(testShader);
	
	triangleCreatedSuccessfully, squareVbo, squareVao, squareEbo := CreateSquareVboVaoEbo();
	if (!triangleCreatedSuccessfully) { return; }
	defer glDeleteVertexArrays(1, *squareVbo);
	defer glDeleteBuffers(1, *squareVao);
	defer glDeleteBuffers(1, *squareEbo);
	
	// +==============================+
	// |          Main Loop           |
	// +==============================+
	windowShouldClose := false;
	while (!windowShouldClose)
	{
		event: SDL_Event;
		while (SDL_PollEvent(*event))
		{
			if event.type ==
			{
				case SDL_QUIT; windowShouldClose = true;
				case SDL_KEYUP; if (event.key.keysym.sym == SDLK_ESCAPE) { windowShouldClose = true; }
				case SDL_WINDOWEVENT;
				{
					if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
					{
						windowSize.x = event.window.data1;
						windowSize.y = event.window.data2;
					}
				}
			}
		}
		
		glViewport(0, 0, xx windowSize.x, xx windowSize.y);
		glClearColor(0.2, 0.3, 0.3, 1.0);
		glClear(GL_COLOR_BUFFER_BIT);
		
		// draw our first triangle
		glUseProgram(testShader);
		glBindVertexArray(squareVao); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
		glBindBuffer(GL_ARRAY_BUFFER, squareVbo);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, squareEbo);
		//glDrawArrays(GL_TRIANGLES, 0, 6);
		glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null);
		
		SDL_GL_SwapWindow(window);
	}
}

GylibDebugOutput :: (dbgLevelU8: u8, message: string)
{
	dbgLevel := cast(DbgLevel)dbgLevelU8;
	WriteToStdOutput(message);
}

AssertionFailure :: (message: string, callString: string) -> bool
{
	PrintLine_D("An assertion failed! % is not true!", callString);
	return false;
}
