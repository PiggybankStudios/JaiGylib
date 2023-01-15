
Shader :: struct
{
	programId: GLuint;
	worldMatrixUniform:      GLint;
	viewMatrixUniform:       GLint;
	projectionMatrixUniform: GLint;
	colorUniform:            GLint;
}

VertexBuffer :: struct
{
	numVertices: s64;
	numIndices: s64;
	vboId: GLuint;
	vaoId: GLuint;
	eboId: GLuint;
}

RenderContext :: struct
{
	boundShader: *Shader;
	boundVertexBuffer: *VertexBuffer;
	
	testShader: Shader;
	square: VertexBuffer;
}

// +--------------------------------------------------------------+
// |                           Shaders                            |
// +--------------------------------------------------------------+
TEST_SHADER_VERTEX_SOURCE ::
#string END
	#version 330 core
	uniform mat4 WorldMatrix;
	uniform mat4 ViewMatrix;
	uniform mat4 ProjectionMatrix;
	layout (location = 0) in vec3 inPosition;
	void main()
	{
		mat4 transformMatrix = ProjectionMatrix * (ViewMatrix * WorldMatrix);
		gl_Position = transformMatrix * vec4(inPosition, 1.0);
	}
END

TEST_SHADER_FRAGMENT_SOURCE ::
#string END
	#version 330 core
	uniform vec4 Color1;
	out vec4 FragColor;
	void main()
	{
	   FragColor = Color1 * vec4(1.0f, 1.0f, 1.0f, 1.0f);
	}
END

// +--------------------------------------------------------------+
// |                           Creation                           |
// +--------------------------------------------------------------+
CompileShader :: (output: *Shader, vertexShaderSource: string, fragmentShaderSource: string) -> bool
{
	ClearPointer(output);
	success: GLint;
	infoLog: [512]GLchar;
	
	// vertex shader
	vertexShader := opengl.glCreateShader(GL_VERTEX_SHADER);
	defer opengl.glDeleteShader(vertexShader);
	vertexSourceCstr := cast(*GLchar)temp_c_string(vertexShaderSource);
	vertexSourceLength := cast(GLint)vertexShaderSource.count;
	opengl.glShaderSource(vertexShader, 1, *vertexSourceCstr, *vertexSourceLength);
	opengl.glCompileShader(vertexShader);
	// check for shader compile errors
	opengl.glGetShaderiv(vertexShader, GL_COMPILE_STATUS, *success);
	if (!success)
	{
		opengl.glGetShaderInfoLog(vertexShader, 512, null, infoLog.data);
		PrintLine_E("Vertex Shader Compilation Failed!\n%", infoLog);
		return false;
	}
	
	// fragment shader
	fragmentShader := opengl.glCreateShader(GL_FRAGMENT_SHADER);
	defer opengl.glDeleteShader(fragmentShader);
	fragmentSourceCstr := cast(*GLchar)temp_c_string(fragmentShaderSource);
	fragmentSourceLength := cast(GLint)fragmentShaderSource.count;
	opengl.glShaderSource(fragmentShader, 1, *fragmentSourceCstr, *fragmentSourceLength);
	opengl.glCompileShader(fragmentShader);
	// check for shader compile errors
	opengl.glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, *success);
	if (!success)
	{
		opengl.glGetShaderInfoLog(fragmentShader, 512, null, infoLog.data);
		PrintLine_E("Fragment Shader Compilation Failed!\n%", infoLog);
		return false;
	}
	
	// link shaders
	output.programId = opengl.glCreateProgram();
	opengl.glAttachShader(output.programId, vertexShader);
	opengl.glAttachShader(output.programId, fragmentShader);
	opengl.glLinkProgram(output.programId);
	// check for linking errors
	opengl.glGetProgramiv(output.programId, GL_LINK_STATUS, *success);
	if (!success)
	{
		opengl.glGetProgramInfoLog(output.programId, 512, null, infoLog.data);
		PrintLine_E("Shader Linking Failed!\n%", infoLog);
		opengl.glDeleteProgram(output.programId);
		return false;
	}
	
	output.worldMatrixUniform      = opengl.glGetUniformLocation(output.programId, "WorldMatrix");
	output.viewMatrixUniform       = opengl.glGetUniformLocation(output.programId, "ViewMatrix");
	output.projectionMatrixUniform = opengl.glGetUniformLocation(output.programId, "ProjectionMatrix");
	output.colorUniform            = opengl.glGetUniformLocation(output.programId, "Color1");
	
	return true;
}

CreateVertexBuffer :: (output: *VertexBuffer, vertices: []v3, indices: []u32) -> bool
{
	ClearPointer(output);
	
	opengl.glGenVertexArrays(1, *output.vaoId);
	opengl.glGenBuffers(1, *output.vboId);
	opengl.glGenBuffers(1, *output.eboId);
	// bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
	opengl.glBindVertexArray(output.vaoId);
	
	opengl.glBindBuffer(GL_ARRAY_BUFFER, output.vboId);
	opengl.glBufferData(GL_ARRAY_BUFFER, size_of(type_of(vertices[0])) * vertices.count, vertices.data, GL_STATIC_DRAW);
	
	opengl.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, output.eboId);
	opengl.glBufferData(GL_ELEMENT_ARRAY_BUFFER, size_of(type_of(indices[0])) * indices.count, indices.data, GL_STATIC_DRAW);
	
	opengl.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, size_of(v3), cast(*void)(0));
	opengl.glEnableVertexAttribArray(0);
	
	// note that this is allowed, the call to glVertexAttribPointer registered vboId as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
	opengl.glBindBuffer(GL_ARRAY_BUFFER, 0); 
	
	// remember: do NOT unbind the EBO while a vaoId is active as the bound element buffer object IS stored in the vaoId; keep the EBO bound.
	//opengl.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	
	// You can unbind the vaoId afterwards so other vaoId calls won't accidentally modify this vaoId, but this rarely happens. Modifying other
	// VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
	opengl.glBindVertexArray(0);
	
	output.numVertices = vertices.count/3;
	output.numIndices = indices.count;
	return true;
}

// +--------------------------------------------------------------+
// |                  Basic Graphics Operations                   |
// +--------------------------------------------------------------+
SetViewport :: (rectangle: rec)
{
	opengl.glViewport(xx rectangle.x, xx rectangle.y, xx rectangle.width, xx rectangle.height);
}

SetUniformF32 :: (uniform: GLint, value: float32)
{
	opengl.glUniform1f(uniform, value);
}
SetUniformV2 :: (uniform: GLint, vector: v2)
{
	opengl.glUniform2f(uniform, vector.x, vector.y);
}
SetUniformV3 :: (uniform: GLint, vector: v3)
{
	opengl.glUniform3f(uniform, vector.x, vector.y, vector.z);
}
SetUniformV4 :: (uniform: GLint, vector: v4)
{
	opengl.glUniform4f(uniform, vector.x, vector.y, vector.z, vector.w);
}
SetUniformColor :: (uniform: GLint, color: Color)
{
	colorf := ToColorf(color);
	SetUniformV4(uniform, colorf.vector);
}
SetUniformMat4 :: (uniform: GLint, matrix: mat4)
{
	opengl.glUniformMatrix4fv(uniform, 1, false, *matrix.values[0][0]);
}

// +--------------------------------------------------------------+
// |                        Render Context                        |
// +--------------------------------------------------------------+
InitRenderContext :: () -> bool
{
	ClearPointer(rc);
	
	if (!CompileShader(*rc.testShader, TEST_SHADER_VERTEX_SOURCE, TEST_SHADER_FRAGMENT_SOURCE)) { return false; }
	
	vertices := v3.[
		.{0, 0, 0},  // top left
		.{1, 0, 0},  // top right
		.{1, 1, 0},  // bottom right
		.{0, 1, 0}   // bottom left 
	];
	indices := u32.[
		0, 1, 3,  // first Triangle
		1, 2, 3   // second Triangle
	];
	if (!CreateVertexBuffer(*rc.square, vertices, indices)) { return false; }
	
	return true;
}

// +--------------------------------------------------------------+
// |                       Render Functions                       |
// +--------------------------------------------------------------+
RcBindShader :: (shader: *Shader)
{
	opengl.glUseProgram(shader.programId);
	rc.boundShader = shader;
}

RcBindVertexBuffer :: (buffer: *VertexBuffer)
{
	opengl.glBindVertexArray(buffer.vaoId); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
	opengl.glBindBuffer(GL_ARRAY_BUFFER, buffer.vboId);
	opengl.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer.eboId);
	rc.boundVertexBuffer = buffer;
}

RcClearScreen :: (clearColor: Color)
{
	clearColorf := ToColorf(clearColor);
	opengl.glClearColor(clearColorf.r, clearColorf.g, clearColorf.b, clearColorf.a);
	opengl.glClear(GL_COLOR_BUFFER_BIT);
}

RcSetProjectionMatrix :: inline (matrix: mat4) { SetUniformMat4(rc.boundShader.projectionMatrixUniform, matrix); }
RcSetViewMatrix       :: inline (matrix: mat4) { SetUniformMat4(rc.boundShader.viewMatrixUniform, matrix); }
RcSetWorldMatrix      :: inline (matrix: mat4) { SetUniformMat4(rc.boundShader.worldMatrixUniform, matrix); }

RcDrawRectangle :: (rectangle: rec, color: Color)
{
	worldMatrix := Mat4_Identity;
	Mat4Transform(*worldMatrix, Mat4Scale2(rectangle.size));
	Mat4Transform(*worldMatrix, Mat4Translate2(rectangle.topLeft));
	RcSetWorldMatrix(worldMatrix);
	SetUniformColor(rc.boundShader.colorUniform, color);
	RcBindVertexBuffer(*rc.square);
	//opengl.glDrawArrays(GL_TRIANGLES, 0, rc.square.numVertices);
	opengl.glDrawElements(GL_TRIANGLES, xx rc.square.numIndices, GL_UNSIGNED_INT, null);
}
