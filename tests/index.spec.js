var chai = require('chai');
var sinon = require('sinon');
chai.use(require('sinon-chai'));
var child_process = require('child_process');
var macmount = require('../lib/index');

describe('Macmount', function() {

  describe('given an error when running the command', function() {

    beforeEach(function() {
      this.childProcessExecFileStub = sinon.stub(child_process, 'execFile');
      this.childProcessExecFileStub.yields(new Error('execFile error'));
    });

    afterEach(function() {
      this.childProcessExecFileStub.restore();
    });

    it('should yield back the error', function(done) {
      macmount.mount('/dev/disk2', function(error) {
        chai.expect(error).to.be.an.instanceof(Error);
        chai.expect(error.message).to.equal('execFile error');
        done();
      });
    });

  });

  describe('given an empty stderr', function() {

    beforeEach(function() {
      this.childProcessExecFileStub = sinon.stub(child_process, 'execFile');
      this.childProcessExecFileStub.yields(null, '', '');
    });

    afterEach(function() {
      this.childProcessExecFileStub.restore();
    });

    it('should not yield an error', function(done) {
      macmount.mount('/dev/disk2', function(error) {
        chai.expect(error).to.be.null;
        done();
      });
    });

  });

  describe('given a blank stderr', function() {

    beforeEach(function() {
      this.childProcessExecFileStub = sinon.stub(child_process, 'execFile');
      this.childProcessExecFileStub.yields(null, '', '      ');
    });

    afterEach(function() {
      this.childProcessExecFileStub.restore();
    });

    it('should not yield an error', function(done) {
      macmount.mount('/dev/disk2', function(error) {
        chai.expect(error).to.be.null;
        done();
      });
    });

  });

  describe('given stderr output', function() {

    beforeEach(function() {
      this.childProcessExecFileStub = sinon.stub(child_process, 'execFile');
      this.childProcessExecFileStub.yields(null, '', 'Disk not found');
    });

    afterEach(function() {
      this.childProcessExecFileStub.restore();
    });

    it('should yield back the error', function(done) {
      macmount.mount('/dev/disk2', function(error) {
        chai.expect(error).to.be.an.instanceof(Error);
        chai.expect(error.message).to.equal('Macmount: Disk not found');
        done();
      });
    });

  });

});
