console.log('inside the commentable object')

const Commentable = { }

Commentable.removeElement = function(commentable_id){
    document.getElementById('id-'+commentable_id).parentElement.remove()
}

export default Commentable
