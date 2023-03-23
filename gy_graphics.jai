
// +--------------------------------------------------------------+
// |                           Imports                            |
// +--------------------------------------------------------------+
#import "stb_image";

#if (GRAPHICS_API == .OPENGL) { #import "GL"; }
else #if (GRAPHICS_API == .D3D11)
{
	#import "d3d11";
	#import "d3d_compiler";
	#import "dxgi";
}
else #if (GRAPHICS_API == .D3D12)
{
	#import "d3d12";
	#import "d3d_compiler";
	#import "dxgi";
}
else #if (GRAPHICS_API == .VULKAN) { #import "Vulkan"; }
else #if (GRAPHICS_API == .METAL) { #import "Metal"; }
else { #assert(false); }

// +--------------------------------------------------------------+
// |                         Type Aliases                         |
// +--------------------------------------------------------------+
#if (GRAPHICS_API == .OPENGL)
{
	UniformLocation :: GLint;
	ShaderId :: GLuint;
	VertexBufferId :: struct { vao, vbo, ebo: GLuint; }
	TextureId :: GLuint;
	GraphicsContext :: struct
	{
		#if (WINDOW_API == .SDL) { glContext: *SDL_GLContext; }
		#if (WINDOW_API == .CUSTOM) //TODO: Does this apply for GLFW as well?
		{
			#if (OS == .WINDOWS) { glContext: *Windows.HGLRC; glDeviceContextHandle: Windows.HDC; }
			#if (OS == .LINUX) { glContext: GLCContext; glContextConfig: GLXFBConfig; }
			#if (OS == .MACOS) { glContext: *NSOpenGLContext; }
		}
		procedures: *GL_Procedures;
	}
}
else #if (GRAPHICS_API == .D3D11)
{
	ConstantsBufferId :: *ID3D11Buffer;
	ShaderId :: struct { vertId: *ID3D11VertexShader; pixId: *ID3D11PixelShader; layoutId: *ID3D11InputLayout; }
	VertexBufferId :: struct { vertId: *ID3D11Buffer; indexId: *ID3D11Buffer; }
	TextureId :: struct
	{
		tex2dId: *ID3D11Texture2D;
		viewId: *ID3D11ShaderResourceView;
		samplerId: *ID3D11SamplerState;
		#place tex2dId; tex1dId: *ID3D11Texture1D;
		#place tex2dId; tex3dId: *ID3D11Texture3D;
	}
	GraphicsContext :: struct
	{
		driverType: D3D_DRIVER_TYPE;
		featureLevel: D3D_FEATURE_LEVEL;
		d3dDevice: *ID3D11Device;
		d3dContext: *ID3D11DeviceContext;
		swapChain: *IDXGISwapChain;
		renderTargetView: *ID3D11RenderTargetView;
		rasterizerState: *ID3D11RasterizerState;
		blendState: *ID3D11BlendState;
	}
}
else { #assert(false); }

// +--------------------------------------------------------------+
// |                         Larger Types                         |
// +--------------------------------------------------------------+
VertexPosOnly :: struct
{
	position: v3;
}
Vertex2D :: struct
{
	position: v3;
	color:    v4;
	texCoord: v2;
}
Vertex3D :: struct
{
	position: v3;
	color:    v4;
	texCoord: v2;
	normal:   v3;
}

VertexBuffer :: struct
{
	isIndexed: bool;
	numVertices: s64;
	numIndices: s64;
	id: VertexBufferId;
	vertexType: Type;
	vertexSize: s64;
}

PixelData :: struct
{
	dimensions: v2i;
	pixelSize: u8;
	rowSize: u64;
	dataSize: u64;
	dataPntr: *void;
	
	#place dataPntr; dataPntrU8: *u8;
	#place dataPntr; dataPntrU32: *u32;
}

TextureOptions :: struct
{
	pixelated: bool = false;
	repeating: bool = false;
	hasMipmap: bool = true;
	// floatChannels: bool = false; //TODO: Add this option
	// hasAntialiasing: bool = false; //TODO: Add this option
}

Texture :: struct
{
	id: TextureId;
	size: v2i;
	using options: TextureOptions;
	hasAlpha: bool;
	
	#place size; width, height: s32;
}

#if (GRAPHICS_API == .OPENGL)
{
	ShaderUniformLocations :: struct
	{
		worldMatrix:      UniformLocation;
		viewMatrix:       UniformLocation;
		projectionMatrix: UniformLocation;
		color:            UniformLocation;
		texture1:         UniformLocation;
		
		#place worldMatrix; locations: [5]UniformLocation;
	}
	#assert(size_of(ShaderUniformLocations) == size_of(type_of(ShaderUniformLocations.locations)));
}

Shader :: struct
{
	id: ShaderId;
	#if (GRAPHICS_API == .OPENGL) { uniforms: ShaderUniformLocations; }
}

#if (GRAPHICS_API == .D3D11)
{
	ShaderConstantsBuffer :: struct
	{
		type: ConstantsBufferType;
		id: ConstantsBufferId;
	}
	
	//NOTE: The values for each enum here specify which slot in the shaders we expect to find this constants buffer
	ConstantsBufferType :: enum #specified
	{
		Matrices :: 0;
		Common :: 1;
	}
	ConstantsBufferType_NumTypes :: cast(u8)( #run enum_values_as_s64(ConstantsBufferType).count );
	
	ShaderConstants_Matrices :: struct
	{
		Type :: ConstantsBufferType.Matrices;
		SlotIndex :: cast(u32)Type;
		
		projectionMatrix: mat4;
		viewMatrix:       mat4;
		worldMatrix:      mat4;
	}
	
	ShaderConstants_Common :: struct
	{
		Type :: ConstantsBufferType.Common;
		SlotIndex :: cast(u32)Type;
		
		color1: v4;
	}
} //#if (GRAPHICS_API == .D3D11)

// +--------------------------------------------------------------+
// |                           Globals                            |
// +--------------------------------------------------------------+
#if (GRAPHICS_API == .OPENGL)
{
	opengl: *GL_Procedures;
}
else #if (GRAPHICS_API == .D3D11)
{
	//TODO: Implement me!
}
else { #assert(false); }

// +--------------------------------------------------------------+
// |                      Texture Functions                       |
// +--------------------------------------------------------------+
CreateTexture :: (output: *Texture, pixelData: PixelData, options: TextureOptions = .{}, reverseByteOrder := false) -> bool
{
	NotNull(pixelData.dataPntr);
	NotNull(output);
	ClearPointer(output);
	
	#if (GRAPHICS_API == .OPENGL)
	{
		opengl.glGenTextures(1, *output.id);
		opengl.glBindTexture(GL_TEXTURE_2D, output.id);
		
		dataFormat: GLenum;
		internalFormat: GLint;
		if (pixelData.pixelSize == 1)
		{
			dataFormat = GL_RED;
			internalFormat = GL_RED;
			output.hasAlpha = false;
		}
		else if (pixelData.pixelSize == 3) //no-alpha
		{
			dataFormat = xx ifx reverseByteOrder then GL_BGR else GL_RGB;
			internalFormat = GL_RGB;
			output.hasAlpha = false;
		}
		else if (pixelData.pixelSize == 4)
		{
			dataFormat = xx ifx reverseByteOrder then GL_BGRA else GL_RGBA;
			internalFormat = GL_RGBA;
			output.hasAlpha = true;
		}
		else { Assert(false, "Unsupported pixelSize passed to CreateTexture"); }
		
		opengl.glTexImage2D(
			target         = GL_TEXTURE_2D,
			level          = 0,
			internalformat = internalFormat,
			width          = xx pixelData.dimensions.width,
			height         = xx pixelData.dimensions.height,
			border         = 0,
			format         = dataFormat,
			type           = GL_UNSIGNED_BYTE,
			pixels         = pixelData.dataPntr
		);
		
		opengl.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, xx ifx options.pixelated then (ifx options.hasMipmap then GL_NEAREST_MIPMAP_NEAREST else GL_NEAREST) else (ifx options.hasMipmap then GL_LINEAR_MIPMAP_LINEAR else GL_LINEAR));
		opengl.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, xx ifx options.pixelated then GL_NEAREST else GL_LINEAR);
		opengl.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, xx ifx options.repeating then GL_REPEAT else GL_CLAMP_TO_EDGE);
		opengl.glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, xx ifx options.repeating then GL_REPEAT else GL_CLAMP_TO_EDGE);
		if (options.hasMipmap) { opengl.glGenerateMipmap(GL_TEXTURE_2D); }
		
		if (pixelData.pixelSize == 1)
		{
			//TODO: This is not supported by WebGL! We need to figure out an alternative or only use this when running on OpenGL proper?
			swizzleMask := GLint.[GL_ONE, GL_ONE, GL_ONE, GL_RED];
			opengl.glTexParameteriv(GL_TEXTURE_2D, GL_TEXTURE_SWIZZLE_RGBA, swizzleMask.data);
		}
	}
	else #if (GRAPHICS_API == .D3D11)
	{
		format: DXGI_FORMAT;
		if (pixelData.pixelSize == 1)
		{
			Unimplemented(); //TODO: Implement me!
		}
		else if (pixelData.pixelSize == 3)
		{
			Unimplemented(); //TODO: Implement me!
		}
		else if (pixelData.pixelSize == 4)
		{
			format = .R8G8B8A8_UNORM;
		}
		else { Assert(false, "Unsupported pixelSize passed to CreateTexture"); }
		
		textureDesc: D3D11_TEXTURE2D_DESC;
		textureDesc.Width          = xx pixelData.dimensions.width;
		textureDesc.Height         = xx pixelData.dimensions.height;
		textureDesc.MipLevels      = 1;
		textureDesc.ArraySize      = 1;
		textureDesc.Format         = format;
		textureDesc.SampleDesc     = DXGI_SAMPLE_DESC.{ Count=1, Quality=0 };
		textureDesc.Usage          = .DEFAULT;
		textureDesc.BindFlags      = D3D11_BIND_FLAG.SHADER_RESOURCE;// | (ifx options.hasMipmap then D3D11_BIND_FLAG.RENDER_TARGET else 0);
		textureDesc.CPUAccessFlags = 0;
		textureDesc.MiscFlags      = 0;//(ifx options.hasMipmap then D3D11_RESOURCE_MISC_FLAG.GENERATE_MIPS else 0);
		
		textureInit: D3D11_SUBRESOURCE_DATA;
		textureInit.pSysMem = pixelData.dataPntr;
		textureInit.SysMemPitch = xx pixelData.rowSize;
		
		createResult := ID3D11Device_CreateTexture2D(globals.graphicsContext.d3dDevice, *textureDesc, *textureInit, *output.id.tex2dId);
		if (Windows.FAILED(createResult)) { WriteLine_E("CreateTexture2D failed!"); return false; }
		
		viewDesc: D3D11_SHADER_RESOURCE_VIEW_DESC;
		viewDesc.Format = .R8G8B8A8_UNORM;
		viewDesc.ViewDimension = .TEXTURE2D;
		viewDesc.Texture2D.MipLevels = textureDesc.MipLevels;
		viewDesc.Texture2D.MostDetailedMip = 0;
		
		createResult = ID3D11Device_CreateShaderResourceView(globals.graphicsContext.d3dDevice, output.id.tex2dId, *viewDesc, *output.id.viewId);
		if (Windows.FAILED(createResult)) { WriteLine_E("CreateShaderResourceView failed!"); return false; }
		
		samplerDesc: D3D11_SAMPLER_DESC;
		samplerDesc.Filter = ifx options.pixelated then D3D11_FILTER.MIN_MAG_MIP_POINT else D3D11_FILTER.MIN_MAG_MIP_LINEAR;
		samplerDesc.AddressU = ifx options.repeating then D3D11_TEXTURE_ADDRESS_MODE.WRAP else D3D11_TEXTURE_ADDRESS_MODE.CLAMP;
		samplerDesc.AddressV = ifx options.repeating then D3D11_TEXTURE_ADDRESS_MODE.WRAP else D3D11_TEXTURE_ADDRESS_MODE.CLAMP;
		samplerDesc.AddressW = ifx options.repeating then D3D11_TEXTURE_ADDRESS_MODE.WRAP else D3D11_TEXTURE_ADDRESS_MODE.CLAMP;
		samplerDesc.ComparisonFunc = .ALWAYS;
		samplerDesc.MipLODBias = 0.0;
		samplerDesc.MaxAnisotropy = 1;
		samplerDesc.BorderColor[0] = 0;
		samplerDesc.BorderColor[1] = 0;
		samplerDesc.BorderColor[2] = 0;
		samplerDesc.BorderColor[3] = 0;
		samplerDesc.MinLOD = 0;
		samplerDesc.MaxLOD = xx D3D11_FLOAT32_MAX;
		createResult = ID3D11Device_CreateSamplerState(globals.graphicsContext.d3dDevice, *samplerDesc, *output.id.samplerId);
		if (Windows.FAILED(createResult)) { WriteLine_E("CreateSamplerState failed!"); return false; }
	}
	else { #assert(false); }
	
	return true;
}

LoadTexture :: (output: *Texture, filePath: string, options: TextureOptions = .{}) -> bool
{
	NotNull(output);
	
	textureFile, openSuccess := file_open(filePath);
	if (!openSuccess) { return false; }
	defer file_close(*textureFile);
	
	textureFileContents, readSuccess := read_entire_file(textureFile);
	if (!readSuccess) { return false; }
	defer free(textureFileContents);
	
	imageSize: v2i;
	numChannels: s32;
	stbPixelPntr := stbi_load_from_memory(textureFileContents.data, xx textureFileContents.count, *imageSize.width, *imageSize.height, *numChannels, 4);
	if (stbPixelPntr == null) { return false; }
	defer stbi_image_free(stbPixelPntr);
	
	pixelData := NewPixelData(imageSize, size_of(u32), stbPixelPntr);
	
	return CreateTexture(output, pixelData, options);
}

NewPixelData :: (dimensions: v2i, pixelSize: u8, dataPntr: *void) -> PixelData
{
	result: PixelData;
	result.dimensions = dimensions;
	result.pixelSize = pixelSize;
	result.rowSize = result.pixelSize * cast(u64)result.dimensions.width;
	result.dataSize = result.rowSize * cast(u64)result.dimensions.height;
	result.dataPntr = dataPntr;
	return result;
}

// +--------------------------------------------------------------+
// |                   Vertex Buffer Functions                    |
// +--------------------------------------------------------------+
_CreateVertexBuffer :: (output: *VertexBuffer, vertices: []$T, indices: []u32 = u32.[]) -> bool
{
	ClearPointer(output);
	
	#if (GRAPHICS_API == .OPENGL)
	{
		output.vertexType = T;
		output.vertexSize = size_of(T);
		output.numVertices = vertices.count;
		output.numIndices = indices.count;
		
		opengl.glGenVertexArrays(1, *output.id.vao);
		opengl.glGenBuffers(1, *output.id.vbo);
		opengl.glGenBuffers(1, *output.id.ebo);
		// bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
		opengl.glBindVertexArray(output.id.vao);
		
		opengl.glBindBuffer(GL_ARRAY_BUFFER, output.id.vbo);
		opengl.glBufferData(GL_ARRAY_BUFFER, size_of(T) * vertices.count, vertices.data, GL_STATIC_DRAW);
		
		opengl.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, output.id.ebo);
		opengl.glBufferData(GL_ELEMENT_ARRAY_BUFFER, size_of(u32) * indices.count, indices.data, GL_STATIC_DRAW);
		
		// PrintLine_W("size_of(T) = %", size_of(T));
		opengl.glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, size_of(T), cast(*void)(0)); //position
		opengl.glEnableVertexAttribArray(0);
		#if (T == Vertex2D || T == Vertex3D)
		{
			// WriteLine_W("Adding color and texCoord to VAO");
			opengl.glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, size_of(T), cast(*void)(size_of(v3))); //color
			opengl.glEnableVertexAttribArray(1);
			opengl.glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, size_of(T), cast(*void)(size_of(v3) + size_of(v4))); //texCoord
			opengl.glEnableVertexAttribArray(2);
		}
		#if (T == Vertex3D)
		{
			// WriteLine_W("Adding normal to VAO");
			opengl.glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, size_of(T), cast(*void)(size_of(v3) + size_of(v4) + size_of(v2))); //normal
			opengl.glEnableVertexAttribArray(3);
		}
		
		// note that this is allowed, the call to glVertexAttribPointer registered id.vbo as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
		opengl.glBindBuffer(GL_ARRAY_BUFFER, 0); 
		
		// remember: do NOT unbind the EBO while a vaoId is active as the bound element buffer object IS stored in the vaoId; keep the EBO bound.
		//opengl.glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
		
		// You can unbind the vaoId afterwards so other vaoId calls won't accidentally modify this vaoId, but this rarely happens. Modifying other
		// VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
		opengl.glBindVertexArray(0);
		
		output.isIndexed = true;
	}
	else #if (GRAPHICS_API == .D3D11)
	{
		output.vertexType = T;
		output.vertexSize = size_of(T);
		output.numVertices = vertices.count;
		output.numIndices = indices.count;
		
		vertBufferDesc: D3D11_BUFFER_DESC;
		vertBufferDesc.Usage = .DEFAULT;
		vertBufferDesc.ByteWidth = xx (size_of(T) * vertices.count);
		vertBufferDesc.BindFlags = .VERTEX_BUFFER;
		vertBufferDesc.CPUAccessFlags = 0;
		
		vertInitData: D3D11_SUBRESOURCE_DATA;
		vertInitData.pSysMem = vertices.data;
		
		createResult := ID3D11Device_CreateBuffer(globals.graphicsContext.d3dDevice, *vertBufferDesc, *vertInitData, *output.id.vertId);
		if (Windows.FAILED(createResult))
		{
			PrintLine_E("CreateBuffer failed: %", createResult);
			return false;
		}
		
		if (indices.count > 0)
		{
			indexBufferDesc: D3D11_BUFFER_DESC;
			indexBufferDesc.Usage = .DEFAULT;
			indexBufferDesc.ByteWidth = xx (size_of(u32) * indices.count);
			indexBufferDesc.BindFlags = D3D11_BIND_FLAG.INDEX_BUFFER;
			indexBufferDesc.CPUAccessFlags = 0;
			
			indexInitData: D3D11_SUBRESOURCE_DATA;
			indexInitData.pSysMem = indices.data;
			
			createResult = ID3D11Device_CreateBuffer(globals.graphicsContext.d3dDevice, *indexBufferDesc, *indexInitData, *output.id.indexId);
			if (Windows.FAILED(createResult))
			{
				PrintLine_E("CreateBuffer failed: %", createResult);
				return false;
			}
			
			output.isIndexed = true;
		}
	}
	else { #assert(false); }
	
	output.numVertices = vertices.count;
	output.numIndices = indices.count;
	return true;
}

CreateVertexBufferPosOnly :: #bake_constants _CreateVertexBuffer(T=VertexPosOnly);
CreateVertexBuffer2D :: #bake_constants _CreateVertexBuffer(T=Vertex2D);
CreateVertexBuffer3D :: #bake_constants _CreateVertexBuffer(T=Vertex3D);
CreateVertexBuffer :: #bake_constants _CreateVertexBuffer(T=VertexPosOnly);
CreateVertexBuffer :: #bake_constants _CreateVertexBuffer(T=Vertex2D);
CreateVertexBuffer :: #bake_constants _CreateVertexBuffer(T=Vertex3D);

// +--------------------------------------------------------------+
// |                       Shader Functions                       |
// +--------------------------------------------------------------+
//NOTE: vertexShaderSource acts as the ONLY source when doing D3D11. fragmentShaderSource does nothing.
CompileShader :: (output: *Shader, shaderSourceStr: string) -> bool
{
	ClearPointer(output);
	#if (GRAPHICS_API == .OPENGL)
	{
		success: GLint;
		infoLog: [512]GLchar;
		
		vertexShaderSource, fragmentShaderSource := ShaderSourceSplit(shaderSourceStr);
		
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
			PrintLine_E("Vertex Shader Compilation Failed!\n%", cast(string)infoLog);
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
			PrintLine_E("Fragment Shader Compilation Failed!\n%", cast(string)infoLog);
			return false;
		}
		
		// link shaders
		output.id = opengl.glCreateProgram();
		opengl.glAttachShader(output.id, vertexShader);
		opengl.glAttachShader(output.id, fragmentShader);
		opengl.glLinkProgram(output.id);
		// check for linking errors
		opengl.glGetProgramiv(output.id, GL_LINK_STATUS, *success);
		if (!success)
		{
			opengl.glGetProgramInfoLog(output.id, 512, null, infoLog.data);
			PrintLine_E("Shader Linking Failed!%", infoLog);
			opengl.glDeleteProgram(output.id);
			return false;
		}
		
		output.uniforms.worldMatrix      = opengl.glGetUniformLocation(output.id, "WorldMatrix");
		output.uniforms.viewMatrix       = opengl.glGetUniformLocation(output.id, "ViewMatrix");
		output.uniforms.projectionMatrix = opengl.glGetUniformLocation(output.id, "ProjectionMatrix");
		output.uniforms.color            = opengl.glGetUniformLocation(output.id, "Color1");
		output.uniforms.texture1         = opengl.glGetUniformLocation(output.id, "Texture1");
	}
	else #if (GRAPHICS_API == .D3D11)
	{
		// +==============================+
		// |    Compile Vertex Shader     |
		// +==============================+
		vertSource, compileResult := D3D11_CompileShader(shaderSourceStr, "vertexShader", "vs_4_0"); 
		if (Windows.FAILED(compileResult))
		{
			WriteLine_E("The shader cannot be compiled.");
			return false; 
		}
		NotNull(vertSource.data);
		
		createResult := ID3D11Device_CreateVertexShader(globals.graphicsContext.d3dDevice, vertSource.data, cast(u64)vertSource.count, null, *output.id.vertId);
		if (Windows.FAILED(createResult))
		{
		    PrintLine_E("CreateVertexShader failed: %", createResult);
		    free(vertSource);
		    return false;
		} 
		
		// +==============================+
		// |     Define Input Layout      |
		// +==============================+
		inputLayout : [3]D3D11_INPUT_ELEMENT_DESC;
		// { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT,     0, 0, D3D11_INPUT_PER_VERTEX_DATA, 0 }, 
		// { "COLOR",    0, DXGI_FORMAT_R32G32B32A32_FLOAT, 12, 0, D3D11_INPUT_PER_VERTEX_DATA, 0 }, 
		// { "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT,        0, 0, D3D11_INPUT_PER_VERTEX_DATA, 0 }, 
		inputLayout[0].SemanticName = "POSITION";
		inputLayout[0].SemanticIndex = 0;
		inputLayout[0].Format = .R32G32B32_FLOAT;
		inputLayout[0].InputSlot = 0;
		inputLayout[0].AlignedByteOffset = 0;
		inputLayout[0].InputSlotClass = .VERTEX_DATA;
		inputLayout[0].InstanceDataStepRate = 0;
		
		inputLayout[1].SemanticName = "COLOR";
		inputLayout[1].SemanticIndex = 0;
		inputLayout[1].Format = .R32G32B32A32_FLOAT;
		inputLayout[1].InputSlot = 0;
		inputLayout[1].AlignedByteOffset = 12;
		inputLayout[1].InputSlotClass = .VERTEX_DATA;
		inputLayout[1].InstanceDataStepRate = 0;
		
		inputLayout[2].SemanticName = "TEXCOORD";
		inputLayout[2].SemanticIndex = 0;
		inputLayout[2].Format = .R32G32_FLOAT;
		inputLayout[2].InputSlot = 0;
		inputLayout[2].AlignedByteOffset = 28;
		inputLayout[2].InputSlotClass = .VERTEX_DATA;
		inputLayout[2].InstanceDataStepRate = 0;
		
		// Create the input layout 
		createResult = ID3D11Device_CreateInputLayout(globals.graphicsContext.d3dDevice, inputLayout.data, cast(u32)inputLayout.count, vertSource.data, cast(u64)vertSource.count, *output.id.layoutId);
		free(vertSource);
		if (Windows.FAILED(createResult))
		{
		    PrintLine_E("CreateInputLayout failed: %", createResult);
		    return false;
		}
		
		// Set the input layout 
		ID3D11DeviceContext_IASetInputLayout(globals.graphicsContext.d3dContext, output.id.layoutId); 
		
		// +==============================+
		// |     Compile Pixel Shader     |
		// +==============================+
		pixShader, compileResult2 := D3D11_CompileShader(shaderSourceStr, "pixelShader", "ps_4_0");
		if (Windows.FAILED(compileResult2))
		{
		    WriteLine_E("The shader cannot be compiled.");
		    return false;
		} 
		
		// Create the pixel shader 
		createResult = ID3D11Device_CreatePixelShader(globals.graphicsContext.d3dDevice, pixShader.data, cast(u64)pixShader.count, null, *output.id.pixId);
		free(pixShader);
		if (Windows.FAILED(createResult))
		{
		    PrintLine_E("CreatePixelShader failed: %", createResult);
		    return false;
		}
	}
	else { #assert(false); }
	
	return true;
}

ShaderSourceSplit :: (sourceStr: string) -> (vertSource: string, fragSource: string)
{
	fragmentIdentIndex := find_index_from_left(sourceStr, "FRAGMENT_SHADER");
	if (fragmentIdentIndex < 0) { return (sourceStr, ""); }
	
	startOfLine := fragmentIdentIndex;
	while (startOfLine > 0 && sourceStr.data[startOfLine] != #char "\n") { startOfLine -= 1; }
	endOfLine := fragmentIdentIndex;
	while (endOfLine < sourceStr.count && sourceStr.data[endOfLine] != #char "\n") { endOfLine += 1; }
	if (endOfLine < sourceStr.count) { endOfLine += 1; }
	
	vertexSource := slice(sourceStr, 0, startOfLine);
	fragmentSource := slice(sourceStr, endOfLine, sourceStr.count - endOfLine);
	return (vertexSource, fragmentSource);
}

#if (GRAPHICS_API == .D3D11)
{
	D3D11_CompileShader :: (source: string, entryPoint: string, shaderModel: string) -> (string, Windows.HRESULT)
	{
		flags := D3DCOMPILE.ENABLE_STRICTNESS; 
		
		#if (DEBUG_BUILD)
		{
			// Set the D3DCOMPILE_DEBUG flag to embed debug information in the shaders. 
			// Setting this flag improves the shader debugging experience, but still allows  
			// the shaders to be optimized and to run exactly the way they will run in  
			// the release configuration of this program. 
			FlagSet(*flags, .DEBUG);
			
			// Disable optimizations to further improve shader debugging 
			FlagSet(*flags, .SKIP_OPTIMIZATION);
		}
		
		defines: []string;
		bytecode, errors, compileResult := D3DCompile(source, "source", defines, null, entryPoint, shaderModel, xx flags, 0);
		defer free(errors);
		
		if (Windows.FAILED(compileResult))
		{
			free(bytecode);
			if (errors) { PrintLine_E("Error msg: %", errors); }
			return ("", compileResult);
		}
		
		return (bytecode, compileResult);
	}
} //#if (GRAPHICS_API == .D3D11)

// +--------------------------------------------------------------+
// |                  Constant Buffer Functions                   |
// +--------------------------------------------------------------+
#if (GRAPHICS_API == .D3D11)
{
	GetConstantsBufferTypeSize :: (type: ConstantsBufferType, padToSixteen := false) -> s64
	{
		//NOTE: Constant buffers have to be 16 byte multiples
		if #complete type ==
		{
			case .Matrices; return CeilTo(size_of(ShaderConstants_Matrices), ifx padToSixteen then 16 else 1);
			case .Common; return CeilTo(size_of(ShaderConstants_Common), ifx padToSixteen then 16 else 1);
			case; Assert(false); return 0;
		}
	}
	
	CreateShaderConstantsBuffer :: (output: *ShaderConstantsBuffer, type: ConstantsBufferType) -> bool
	{
		ClearPointer(output);
		output.type = type;
		bufferTypeSize := GetConstantsBufferTypeSize(type, true);
		bufferDesc: D3D11_BUFFER_DESC;
		bufferDesc.Usage = .DYNAMIC;
		bufferDesc.ByteWidth = xx bufferTypeSize;
		bufferDesc.BindFlags = .CONSTANT_BUFFER;
		bufferDesc.CPUAccessFlags = .WRITE;
		ID3D11Device_CreateBuffer(globals.graphicsContext.d3dDevice, *bufferDesc, null, *output.id);
		DebugAssert(output.id != null);
		return (output.id != null);
	}
} //#if (GRAPHICS_API == .D3D11)

