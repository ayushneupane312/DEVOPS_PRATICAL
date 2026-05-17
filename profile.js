function getUserProfile(userId) {
  return {
    id: userId,
    name: "John Doe",
    email: "john@example.com",
    createdAt: new Date().toISOString()
  };
}

function updateUserProfile(userId, data) {
  return { ...getUserProfile(userId), ...data };
}

module.exports = { getUserProfile, updateUserProfile };
