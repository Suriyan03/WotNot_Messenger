<template>
  <div class="modal-backdrop" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Message Generator</h2>
        <span class="close-btn" @click="$emit('close')">&times;</span>
      </div>

      <div class="generator-body">
        <label for="prompt">Enter your message prompt:</label>
        <input 
          id="prompt" 
          v-model="promptText" 
          type="text" 
          placeholder="e.g., Send a Diwali wish to customers"
          @keyup.enter="generateMessage"
        />

        <button @click="generateMessage" :disabled="isLoading || !promptText" class="generate-btn">
          <i class="bi bi-magic mr-2"></i> {{ isLoading ? 'Generating...' : 'Generate Message' }}
        </button>

        <label for="generated-output" class="mt-4">Generated Template:</label>
        <textarea 
          id="generated-output" 
          v-model="generatedMessage" 
          rows="10" 
          placeholder="Your AI-generated message will appear here..." 
          readonly>
        </textarea>
        
        <button @click="useTemplate" :disabled="!generatedMessage" class="use-btn">
          Use This Template
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'MessageGeneratorModal',
    data() {
        return {
            promptText: '',
            generatedMessage: '',
            isLoading: false,
            apiUrl: process.env.VUE_APP_API_URL,
        };
    },
    methods: {
        async generateMessage() {
            if (!this.promptText || this.isLoading) return;

            this.isLoading = true;
            this.generatedMessage = ''; // Clear previous message
            const token = localStorage.getItem('access_token');
            
            try {
                const response = await axios.post(
                    `${this.apiUrl}/user/generate-message/`, // Your working backend endpoint
                    { prompt: this.promptText },
                    { headers: { 'Authorization': `Bearer ${token}` } }
                );

                // The backend returns {"message": "..."}
                this.generatedMessage = response.data.message || "Could not generate a message. Try a different prompt.";
                
            } catch (error) {
                console.error("AI Message Generation Failed:", error.response?.data?.detail || error.message);
                this.generatedMessage = `Error: Failed to generate message. Check your token and backend logs.`;
            } finally {
                this.isLoading = false;
            }
        },
        useTemplate() {
            // Emits the generated message up to the parent component (ManageTemplatesView)
            this.$emit('use-template', this.generatedMessage);
            this.$emit('close'); // Close the modal
        }
    }
};
</script>

<style scoped>
/* Scoped styles to ensure they only affect this component */

.modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.6);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1050; /* Higher than your dropdowns and wallet modal */
}

.modal-content {
    background-color: #ffffff;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
    width: 550px; /* Wider for the textarea */
    max-width: 90%;
    position: relative;
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    border-bottom: 1px solid #eee;
    padding-bottom: 10px;
}

.close-btn {
    font-size: 24px;
    font-weight: bold;
    cursor: pointer;
    color: #aaa;
}

.close-btn:hover {
    color: #333;
}

.generator-body label {
    display: block;
    margin-bottom: 5px;
    font-weight: 600;
    color: #333;
}

.generator-body input,
.generator-body textarea {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    font-size: 14px;
}

.generator-body textarea {
    resize: vertical;
}

.generate-btn {
    background-color: #10b981; /* Green tone */
    color: white;
    padding: 10px 20px;
    margin-right: 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.generate-btn:hover:not(:disabled) {
    background-color: #059669;
}

.use-btn {
    background-color: #1e40af; /* Blue tone for action */
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.use-btn:hover:not(:disabled) {
    background-color: #1e3a8a;
}

button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

</style>