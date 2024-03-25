from flask import Flask, Response

app = Flask(__name__)

@app.route('/metrics')
def metrics():
    # Path inside the container
    file_path = '/data/metrics.pom'
    try:
        with open(file_path, 'r') as file:
            content = file.read()
        return Response(content, mimetype='text/plain')
    except FileNotFoundError:
        return Response("Metrics file not found.", status=404, mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
