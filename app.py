import os
import shutil
import subprocess
import time
import zipfile
import gradio as gr

def compile_socket_app(project_zip, platform):
    """
    Takes an uploaded zip file, unpacks it inside a sandboxed session folder,
    triggers the Socket Supply Co command line compiler, verifies outputs, 
    and compresses back the build deliverables into a downloadable payload.
    """
    # 1. Input Validation Guard Rails
    if project_zip is None:
        return None, "❌ Compilation Aborted: Please drag and drop or upload your project assets ZIP file first."
        
   # Change this line inside compile_socket_app:
   if platform not in ["linux", "android", "win"]:
        return None, "❌ Compilation Aborted: An unsupported target platform was requested."


    # Create an isolated workflow tracking ID inside /tmp to support multi-user operations safely
    session_id = f"socket_build_{int(time.time())}"
    workspace_dir = os.path.join("/tmp/workspaces", session_id)
    os.makedirs(workspace_dir, exist_ok=True)

    try:
        # 2. Extract Project Asset Archive Payloads
        print(f"[{session_id}] Unpacking project zip archive into temporary workspace: {workspace_dir}")
        with zipfile.ZipFile(project_zip.name, 'r') as zip_ref:
            zip_ref.extractall(workspace_dir)

        # Confirm critical configuration parameters exist in the user submission space
        ini_check_path = os.path.join(workspace_dir, "socket.ini")
        if not os.path.exists(ini_check_path):
            shutil.rmtree(workspace_dir, ignore_errors=True)
            return None, "❌ Validation Error: Could not find 'socket.ini' in the root folder of your ZIP payload."

        # 3. Trigger Native Compiler Script Strings
        build_command = f"ssc build --platform={platform}"
        print(f"[{session_id}] Executing core toolchain framework command: {build_command}")
        
        # Execute terminal task commands and grab background system error and log print readouts
        process = subprocess.run(
            build_command, 
            shell=True, 
            cwd=workspace_dir, 
            capture_output=True, 
            text=True
        )

        # Handle runtime compile exceptions or explicit code crashes
        if process.returncode != 0:
            error_log = process.stderr if process.stderr else "Unknown native compilation fault."
            shutil.rmtree(workspace_dir, ignore_errors=True)
            return None, f"❌ Socket Compiler Runtime Error:\n\n{error_log}"

        # 4. Extract and Locate Valid Deliverable Binary Streams
        # Socket Runtime places built standalone artifacts directly into an internal 'build' path
        output_dir = os.path.join(workspace_dir, "build")
        if not os.path.exists(output_dir):
            shutil.rmtree(workspace_dir, ignore_errors=True)
            return None, "❌ Error: Compilation run passed, but output 'build' artifact directory could not be resolved."

        # 5. Compress Build Output Directory Deliverables
        dist_zip_output_path = os.path.join("/tmp", f"{session_id}_distribution")
        shutil.make_archive(dist_zip_output_path, 'zip', output_dir)
        final_zip_file = f"{dist_zip_output_path}.zip"

        # Wipe container directory tracks safely to free platform memory resources
        shutil.rmtree(workspace_dir, ignore_errors=True)
        
        # Parse terminal console history log to provide visual telemetry down onto the Gradio dashboard
        compiler_stdout = process.stdout if process.stdout else "Compilation completed successfully with unlogged telemetry."
        success_message = f"✨ SUCCESS! Your native Socket Supply application has been built for: {platform.upper()}\n\n--- System Build Telemetry ---\n{compiler_stdout}"
        
        return final_zip_file, success_message

    except Exception as e:
        shutil.rmtree(workspace_dir, ignore_errors=True)
        return None, f"💥 Critical Cloud Service Exception Interruption: {str(e)}"


# ==========================================
# CUSTOM DARK & GOLDEN YELLOW GRADIO INTERFACE DESIGN
# ==========================================

# Inject global CSS rules to force a consistent dark UI aesthetic matching your premium design specifications
custom_css = """
body, .gradio-container { background-color: #121212 !important; color: #E0E0E0 !important; }
gr-markdown h1, h1 { color: #FFD700 !important; font-family: sans-serif; font-weight: bold; }
.primary-btn { background-color: #FFD700 !important; color: #000000 !important; font-weight: bold !important; border-radius: 8px !important; }
.primary-btn:hover { background-color: #E6C200 !important; }
.input-box, .output-box, textarea, input, .file-preview { background-color: #1A1D24 !important; color: #FFFFFF !important; border: 1px solid #2D3139 !important; }
"""

# Build interface layouts via Gradio Blocks
with gr.Blocks(theme=gr.themes.Default(primary_hue="yellow", secondary_hue="slate"), css=custom_css) as demo:
    gr.Markdown(
        """
        # ⚡ Excel CBT Build Factory
        Welcome to your remote multi-platform compilation engine. Upload your arranged client application archive (containing your `src/` directory and your `socket.ini` configurations) to instantly spin up standalone platform bundles.
        """
    )
    
    with gr.Row():
        with gr.Column(scale=1):
            gr.Markdown("### 📥 Source Inputs")
            # File component allows zip drag-and-drop actions natively
            file_input = gr.File(label="Upload Project Archive (ZIP Only)", file_types=[".zip"], elem_classes="input-box")
            
            # Selection controls for choosing output types
            platform_select = gr.Radio(choices=["linux", "android", "win"], label="Choose Build Target File Extension", value="android")
            
            # Execute compiler button actions mapping into custom class styling parameters
            build_btn = gr.Button("🚀 Trigger Compilation Pipeline", variant="primary", elem_classes="primary-btn")
            
        with gr.Column(scale=1):
            gr.Markdown("### 📤 Compiler Outputs")
            # Delivery container path mapping handles output file triggers automatically
            file_output = gr.File(label="Download Compiled Application Package Bundle", elem_classes="output-box")
            log_output = gr.Textbox(label="System Compiler Telemetry Logs", lines=12, interactive=False, elem_classes="input-box")

    # Wire up single execution click bindings
    build_btn.click(
        fn=compile_socket_app,
        inputs=[file_input, platform_select],
        outputs=[file_output, log_output]
    )

# CRITICAL SYSTEM NOTE: Dynamically read custom server routing assignments assigned by Railway configuration engines
railway_port = int(os.environ.get("PORT", 8080))
demo.launch(server_name="0.0.0.0", server_port=railway_port)
